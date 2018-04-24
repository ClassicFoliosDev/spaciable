class MigrateDefaultFaqText < ActiveRecord::Migration[5.0]
  def up
    puts "============"
    puts "Migrating FAQ text contents"

    white_powder = DefaultFaq.find_by(question: "There is a white powder on my walls. Is this a defect?")
    white_powder&.update_attributes(answer: "<p>No. You may notice a white, chalk-like substance on the exterior brickwork of your new home.  This isn’t a defect, just the natural salts escaping from the building materials.  Efflorescence will be washed away naturally by rainfall and will stop once the salts are exhausted.</p>")
    white_powders = Faq.where(question: "There is a white powder on my walls. Is this a defect?")
    white_powders&.update_all(answer: "<p>No. You may notice a white, chalk-like substance on the exterior brickwork of your new home.  This isn’t a defect, just the natural salts escaping from the building materials.  Efflorescence will be washed away naturally by rainfall and will stop once the salts are exhausted.</p>")

    puts "Updated white powders answer for #{white_powders.count} developers"

    carpet = DefaultFaq.find_by(question: "How can I protect my new carpet?")
    carpet&.update_attributes(answer: "<p>You should vacuum your carpet regularly in order to remove dirt and grit.  Any stains should be treated as quickly as possible, blotting the area, not rubbing.  For large or persistent stains, you should call a professional carpet cleaner.</p>")
    carpets = Faq.where(question: "How can I protect my new carpet?")
    carpets&.update_all(answer: "<p>You should vacuum your carpet regularly in order to remove dirt and grit.  Any stains should be treated as quickly as possible, blotting the area, not rubbing.  For large or persistent stains, you should call a professional carpet cleaner.</p>")

    puts "Updated carpet answer for #{carpets.count} developers"

    brick = DefaultFaq.find_by(question: "Can I cover my air bricks?")
    brick&.update_attributes(answer: "<p>If your home has a suspended ground floor, you will find air bricks outside at low level to provide ventilation.  Please ensure that no rubbish, garden material or soil covers the damp-proof course or air bricks.  Soil and paving or patio material should be kept a minimum of 150mm or two brick courses below the damp-proof course.</p>")
    bricks = Faq.where(question: "Can I cover my air bricks?")
    bricks&.update_all(answer: "<p>If your home has a suspended ground floor, you will find air bricks outside at low level to provide ventilation.  Please ensure that no rubbish, garden material or soil covers the damp-proof course or air bricks.  Soil and paving or patio material should be kept a minimum of 150mm or two brick courses below the damp-proof course.</p>")

    puts "Updated air bricks answer for #{bricks.count} developers"

    mcb_answer = "<p>A miniature circuit breaker (MCB)on your consumer unit usually trips either because a light bulb has blown or a faulty appliance has overloaded the circuit or caused a short circuit somewhere in the system.&nbsp; Instead of just switching the MCB back on:</p>

    <ul>
	    <li>Go to your consumer unit and identify which circuit has been affected; the relevant MCB will be in the &lsquo;off&rsquo; position</li>
	    <li>Disconnect (rather than just switch off)any appliances on this circuit</li>
	    <li>Switch the MCB back on to restore the circuit</li>
	    <li>Reconnect the appliances in turn and see if the MCB fuses again.&nbsp; If it does, this will show which is the faulty appliance</li>
    </ul>

    <p>If you can&rsquo;t find the fault, please call an electrician.</p>

    <p>It is important to note that some faults are intermittent and everything may work for a short time.&nbsp; In this case, don&rsquo;t keep switching the MCB and instead call a suitably qualified electrician to correct the fault.</p>
    "
    mcb = DefaultFaq.find_by(question: "Why has an MCB tripped?")
    mcb&.update_attributes(answer: mcb_answer)
    mcbs = Faq.where(question: "Why has an MCB tripped?")
    mcbs&.update_all(answer: mcb_answer)

    puts "Updated mcb answer for #{mcbs.count} developers"

    water_answer = "<p>First check the following:</p>

    <ul>
      <li>The timer is programmed correctly (where applicable), with accurate time and date and no active override settings</li>
      <li>You have allowed enough time for the system to heat up</li>
    </ul>

    <p>Please note, during the winter, there may be a warm-up period of at least 60 minutes before the effects of any heating will be noticed.</p>

    <p>In the event of a heating system breakdown, please consult your homeowner&rsquo;s manual for further advice, as the developer may be liable for issues occurring shortly after legal completion. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>"

    water_question = DefaultFaq.find_by(question: "What should I do if I have no heating or hot water?")
    water_question&.update_attributes(answer: water_answer)
    water_questions = Faq.where(question: "What should I do if I have no heating or hot water?")
    water_questions&.update_all(answer: water_answer)

    puts "Updated no heating or hot water answer for #{water_questions.count} developers"

    radiator_answer = "<p>If you experience a radiator failing to heat this could be an indication of air in the system.&nbsp; This is a common problem, particularly in newly installed heating systems.&nbsp; In this instance, you should follow the steps below:</p>

    <ul>
      <li>To release the air, attach a radiator bleeding key to the bleed valve and turn it anticlockwise.&nbsp; This should be done gently to avoid the valve being removed completely</li>
      <li>Open the valve until a hissing sound can be heard; this will indicate that the air is escaping.&nbsp; Hold a cloth beneath the valve to protect both the floor surface and your hands from any hot water that escapes</li>
      <li>When water starts to escape from the radiator, close the bleed valve by turning it clockwise</li>
    </ul>"

    radiator_question = DefaultFaq.find_by(question: "My radiator is not heating properly. What should I do?")
    radiator_question&.update_attributes(answer: radiator_answer)
    radiator_questions = Faq.where(question: "My radiator is not heating properly. What should I do?")
    radiator_questions&.update_all(answer: radiator_answer)

    puts "Updated radiator answer for #{radiator_questions.count} developers"

    towel_rail_question = DefaultFaq.find_by(question: "I have heated towel rails – why does my bathroom feel cold?")
    towel_rail_question&.update_attributes(answer: "<p>If heated towel rails have been installed, they may be there not only to warm towels but also to heat the room. If your bathroom feels cold, it might be because you&rsquo;ve completely covered your rails with towels.</p>")
    towel_rail_questions = Faq.where(question: "I have heated towel rails – why does my bathroom feel cold?")
    towel_rail_questions&.update_all(answer: "<p>If heated towel rails have been installed, they may be there not only to warm towels but also to heat the room. If your bathroom feels cold, it might be because you&rsquo;ve completely covered your rails with towels.</p>")

    puts "Updated towel rail answer for #{towel_rail_questions.count} developers"

    water_draining_answer = "<p>Slow draining water, or water that is not draining at all, indicates a blockage. To clear a blockage:</p>

    <ul>
      <li>Try using a flexible rod or plunger/suction cup to remove it</li>
      <li>If a plunger doesn&rsquo;t work, pour in a drain cleaner. Make sure you follow the manufacturer&rsquo;s instructions on any drain cleaning product</li>
      <li>If you try to remove a blockage from a sink by hand, please wear gloves to protect your hands and place a bucket under the sink trap. Unscrew the trap, reach in and remove the blockage, then screw the trap back into place</li>
      <li>For serious plumbing issues, please contact a plumber</li>
    </ul>

    <p>To help prevent blockages:</p>

    <ul>
      <li>Don&rsquo;t empty large quantities of bleach or similar cleaning agents into the system</li>
      <li>Don&rsquo;t empty cooking oil or anything similar down the sink</li>
      <li>Don&rsquo;t put anything other than toilet paper down your WC</li>
      <li>Don&rsquo;t use excess washing powder in your washing machine</li>
      <li>Regularly remove hairs that get trapped in the basin/bath/shower plughole</li>
      <li>Use a plughole protector to prevent sink blockages</li>
    </ul>"

    water_draining = DefaultFaq.find_by(question: "Why is water draining slowly in my kitchen/bathroom?")
    water_draining&.update_attributes(answer: water_draining_answer)
    water_drainings = Faq.where(question: "Why is water draining slowly in my kitchen/bathroom?")
    water_drainings&.update_all(answer: water_draining_answer)

    puts "Updated water draining answer for #{water_drainings.count} developers"

    gas_answer = "<ul>
      <li>Don&rsquo;t smoke or light matches&nbsp;</li>
      <li>Don&rsquo;t turn electrical switches on or off, including doorbells and light switches&nbsp;</li>
      <li>Open doors and windows&nbsp;</li>
      <li>Turn off the meter at the control valve (unless it is in a confined space and you&rsquo;re putting yourself at risk)</li>
      <li>Call the free 24 hour National Gas Emergency helpline on 0800 111 999</li>
    </ul>"

    gas_question = DefaultFaq.find_by(question: "What should I do if I smell gas?")
    gas_question&.update_attributes(answer: gas_answer)
    gas_questions = Faq.where(question: "What should I do if I smell gas?")
    gas_questions&.update_all(answer: gas_answer)

    puts "Updated gas answer for #{gas_questions.count} developers"

    structure_answer = "<p>When you purchased your home, special terms and conditions were contained within your Title Deeds or Lease.&nbsp; They may restrict or prohibit the changes that you can make to your home.&nbsp; You might also need planning permission from your local authority if you wish to build an extension or make changes that affect the external appearance of your home.</p>

    <p>You should never remove or cut into any roof timbers, joists or walls without first seeking the expert advice of a qualified professional.&nbsp; Please contact us if you or your contractor requires access to the health and safety file for the development.</p>

    <p>You should also remember the following safety recommendations when doing DIY:</p>

    <ul>
      <li>Take appropriate safety precautions, such as ensuring there is adequate ventilation</li>
      <li>Always use the relevant protective equipment, e.g., a face mask or safety goggles</li>
      <li>Ensure you have right tools for the job and that they are in good working order</li>
      <li>Use a detector to check for hidden pipes or cables beneath wall or floor surfaces before drilling</li>
      <li>If you&rsquo;re using a ladder, make sure it&rsquo;s in good condition and suitable for its purpose&nbsp;</li>
      <li>Set up the ladder at a stable angle (one out to four up)and either secure at the top or wedge the bottom with a heavy object to prevent slipping</li>
      <li>Don&rsquo;t extend the ladder beyond the manufacturer&rsquo;s recommendations and always re-position your ladder instead of overstretching</li>
      <li>Beware of overhead dangers, e.g., power cables</li>
    </ul>"

    structure_question = DefaultFaq.find_by(question: "Can I make changes to the structure of my home?")
    structure_question&.update_attributes(answer: structure_answer)
    structure_questions = Faq.where(question: "Can I make changes to the structure of my home?")
    structure_questions&.update_all(answer: structure_answer)

    puts "Updated structure answer for #{structure_questions.count} developers"

    energy_answer = "<p>To reduce your energy use:</p>
    <ul>
      <li>Don&rsquo;t set your heating thermostat higher than necessary; turning your heating settings down by 1°C will reduce your energy consumption and your heating bills</li>
      <li>Programme your heating and hot water to only turn on at the times you need it</li>
      <li>Wait until you have a full load before using your washing machine or dishwasher</li>
      <li>Where possible, allow clothes to dry naturally rather than using a tumble dryer</li>
      <li>Let food cool down before putting it in the fridge or freezer</li>
      <li>Switch lights off when you don&rsquo;t need them</li>
      <li>Use energy saving light bulbs</li>
      <li>Use “economy” settings on your appliances and turn them off when not in use, instead of leaving them on standby</li>
      <li>If buying a new boiler or kitchen appliance in the future, choose one with a higher energy efficiency rating</li>
      <li>Unplug portable devices once they are fully charged</li>
      <li>Run your washing machine at 30°C; most washing detergents are specially designed to work well at low temperatures</li>
      <li>Match pan size to ring size and cover pans so that the contents heat up more quickly</li>
    </ul>

    <p>To reduce your water consumption:</p>

    <ul>
      <li>Repair dripping taps</li>
      <li>Only fill the kettle with the amount of water you need</li>
      <li>Have a shower instead of a bath</li>
      <li>Use a save-a-flush bag in your toilet cistern</li>
      <li>Don&rsquo;t leave the tap running while brushing your teeth or shaving</li>
      <li>Wash your car using a bucket and sponge, rather than a hose</li>
      <li>Wash your fruit and vegetables in a bowl rather than under a running tap</li>
      <li>Put a jug of water in the fridge, instead of running the tap until the water is cold</li>
      <li>If you have a garden, water it in the morning or evening, when the temperature is lower so less water will evaporate</li>
      <li>Reuse washing up water for your houseplants or garden</li>
    </ul>"

    energy_question = DefaultFaq.find_by(question: "What steps can I take to save energy and water?")
    energy_question&.update_attributes(answer: energy_answer)
    energy_questions = Faq.where(question: "What steps can I take to save energy and water?")
    energy_questions&.update_all(answer: energy_answer)

    puts "Updated energy answer for #{energy_questions.count} developers"

    puts "Finished updating FAQ text contents"
    puts "================"
  end

  def down
    # No reverse for these text content changes, to change the text again, migrate forward
  end
end
