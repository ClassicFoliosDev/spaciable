class FixDefaultFaq < ActiveRecord::Migration[5.0]
  def up
    tv_faq = DefaultFaq.find_by(question: %(Will my existing TV Licence cover my new home?))

    return unless tv_faq
    tv_faq.update_attributes(answer: %(<p>Please be aware that your television licence doesn&rsquo;t automatically move with you, and it&rsquo;s important that you notify TV Licensing so they can transfer your licence to your new address:</p>

                                       <p>Telephone: 0300 790 6165<br>
                                       Website:  www.tvlicensing.co.uk</p>
                                     ))
  end

  def down
    # No reverse for this data migration
  end
end
