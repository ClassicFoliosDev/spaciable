# frozen_string_literal: true

class RoomItem < ApplicationRecord
  belongs_to :room_configuration, optional: false
  has_many :choices, dependent: :destroy, autosave: true
  has_many :room_choices, dependent: :destroy
  belongs_to :room_itemable, polymorphic: true

  attr_accessor :category_item_ids

  delegate :to_s, to: :name
  delegate :room, to: :room_configuration

  after_initialize do
    # remember the original type and id i.e. Finish / 14
    @original_room_itemable_type = room_itemable_type
    @original_room_itemable_id = room_itemable_id
  end

  # Add the selected choices, then save.  As choices are 'autosaved' they
  # will be commited to the database at the same time and in the same transaction
  # as the room_item
  def persist(categoryids)
    add_choices(categoryids)
    save # save the room_item and choices in one transaction
  end

  # Update the selected choices, then save.  As choices are 'autosaved' they
  # will be commited to the database at the same time and in the same transaction
  # as the room_item
  def update_room_item(categoryids, categorytype, categoryid, itemname)
    # update the associated type/id/name
    self.room_itemable_type = categorytype
    self.room_itemable_id = categoryid
    self.name = itemname

    # if the type and/or id have chenged, clear out all the choices
    if room_itemable_type != @original_room_itemable_type ||
       room_itemable_id.to_i != @original_room_itemable_id.to_i
      archive_choices(choices.to_a.map(&:choiceable_id))
    end

    # now go through and compare choices - no need to pass
    # type/id as they are set above
    update_choices(categoryids)

    save
  end

  # Update the choices by checking new against old
  def update_choices(updatedchoices)
    # sort choiceable_ids from all choices not currently marked for destructon
    oldchoices = choices.to_a
                        .reject(&:archived?)
                        .map(&:choiceable_id)
                        .sort

    # sort new populated category_ids converted to integers
    newchoices = updatedchoices.select(&:present?)
                               .map(&:to_i)
                               .sort

    archive_choices(oldchoices - newchoices)
    add_choices(newchoices - oldchoices)
  end

  # Add the new choices
  def add_choices(choiceids)
    # unarchive existing (reselected) choices
    archived = choices.select { |c| choiceids.include?(c.choiceable_id) }
    archived&.map { |a| a.archived = false }

    choiceids -= archived&.map(&:choiceable_id) # remove archived from new choices

    # now go and add the remaining new ones
    category = room_itemable_type.slice(/.+?(?=Category)/)
    choiceids.each do |choice|
      next if choice.to_i.zero?

      choices.build(
        choiceable_type: category,
        choiceable_id: choice.to_i,
        room_item_id: id
      )
    end
  end

  # mark all the removed ones as archived
  def archive_choices(choiceids)
    choices.map { |c| c.archived = true if choiceids.include?(c.choiceable_id) }
  end
end
