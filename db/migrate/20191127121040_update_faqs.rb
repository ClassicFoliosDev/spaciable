class UpdateFaqs < ActiveRecord::Migration[5.0]
  # update the faqs for each developer/development to the new defaults
  # the 'old' faqs have been copied exactly as they display in the database
  def up
    DefaultFaq.where(question:"There is a white powder on my walls. Is this a defect?")
              .update(question: "There is a white powder on my external walls. Is this a defect?")
    Faq.where(question:"There is a white powder on my walls. Is this a defect?")
       .update(question: "There is a white powder on my external walls. Is this a defect?")
    DefaultFaq.where(answer: "<p>No. You may notice a white, chalk-like substance on the exterior brickwork of your new home.&nbsp; This isn&rsquo;t a defect, just the natural salts escaping from the building materials.&nbsp; Efflorescence will be washed away naturally by rainfall and will stop once the salts are exhausted.&nbsp;</p>\n  ")
              .update(answer: "<p>No. You may notice a white chalk-like substance on the exterior brickwork of your new home.&nbsp; This isn&rsquo;t a defect, just the natural salts escaping from the building materials.&nbsp; Efflorescence will be washed away naturally by rainfall and will stop once the salts are exhausted.&nbsp;</p>")
    Faq.where(answer: "<p>No. You may notice a white, chalk-like substance on the exterior brickwork of your new home.&nbsp; This isn&rsquo;t a defect, just the natural salts escaping from the building materials.&nbsp; Efflorescence will be washed away naturally by rainfall and will stop once the salts are exhausted.&nbsp;</p>\n  ")
       .update(answer: "<p>No. You may notice a white chalk-like substance on the exterior brickwork of your new home.&nbsp; This isn&rsquo;t a defect, just the natural salts escaping from the building materials.&nbsp; Efflorescence will be washed away naturally by rainfall and will stop once the salts are exhausted.&nbsp;</p>")

    # Why are there small cracks in my walls and ceilings?
    cracks_old = "<p>The materials that were used to build your new home contained a lot of water. This water will take around 6–18 months to evaporate completely, which is known as the drying out process. During this time, the plasterwork in your home may shrink slightly, causing some small changes to occur. One of these changes is small cracks appearing in plastered finishes, which can be filled using a suitable product and covered with paint.</p>\n\n  <p>Below is a list of the other common signs of drying out and simple steps you can take to deal with them:</p>\n\n  <ul>\n  \t<li>Baths and shower trays may drop very slightly. You should reseal them around the edges with a silicone sealant</li>\n  \t<li>Wooden door frames and windows may move. Simply adjust the door or window keep if necessary</li>\n  \t<li>Nail or screw heads may pop out of plastered finishes. Hammer or screw them down, fill the hole with a suitable product and cover with paint</li>\n  </ul>\n\n  <p>Further advice on the drying out process can be found in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    cracks_updated = "<p>The materials that were used to build your new home contained a lot of water. This water will take around 6–18 months to evaporate completely, which is known as the drying out process. During this time, the plasterwork in your home may shrink slightly, causing some small changes to occur. One of these changes is small cracks appearing in plastered finishes, which can be filled using a suitable product and covered with paint.</p>
                      <p>Below is a list of the other common signs of drying out and simple steps you can take to deal with them:</p>
                      <ul>
                        <li>Baths and shower trays may drop very slightly. You should reseal them around the edges with a silicone sealant</li>
                        <li>Wooden door frames and windows may move. Simply adjust the door or window keep if necessary</li>
                        <li>Nail or screw heads may pop out of plastered finishes. Hammer or screw them down, fill the hole with a suitable product and cover with paint</li>
                      </ul>
                      <p>Further advice on the drying out process can be found in the homeowner&rsquo;s manual uploaded to your document library after legal completion &#40;where applicable&#41;.</p>"
    DefaultFaq.where(answer: cracks_old)
              .update(answer: cracks_updated)
    Faq.where(answer: cracks_old)
       .update(answer: cracks_updated)

    # Why has my bath or shower tray dropped?
    bath_old = "<p>The materials that were used to build your new home contained a lot of water. This water will take around 6–18 months to evaporate completely, which is known as the drying out process. During this time, the plasterwork in your home may shrink slightly, causing some small changes to occur. One of the changes is that baths and shower trays may drop very slightly and will simply need to be resealed around the edges with a silicone sealant.</p>\n\n  <p>Below is a list of the other common signs of drying out and simple steps you can take to deal with them:</p>\n\n  <ul>\n  \t<li>Small shrinkage cracks may appear in plastered finishes. These can be filled using a suitable product and covered with paint</li>\n  \t<li>Wooden door frames and windows may move. Simply adjust the door or window keep if necessary</li>\n  \t<li>Nail or screw heads may pop out of plastered finishes. Hammer or screw them down, fill the hole with a suitable product and cover with paint</li>\n  </ul>\n\n  <p>Further advice on the drying out process can be found in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    bath_updated = "<p>The materials that were used to build your new home contained a lot of water. This water will take around 6–18 months to evaporate completely, which is known as the drying out process. During this time, the plasterwork in your home may shrink slightly, causing some small changes to occur. One of the changes is that baths and shower trays may drop very slightly and will simply need to be resealed around the edges with a silicone sealant.</p>
                    <p>Below is a list of the other common signs of drying out and simple steps you can take to deal with them:</p>
                    <ul>
                      <li>Small shrinkage cracks may appear in plastered finishes. These can be filled using a suitable product and covered with paint</li>
                      <li>Wooden door frames and windows may move. Simply adjust the door or window keep if necessary</li>
                      <li>Nail or screw heads may pop out of plastered finishes. Hammer or screw them down, fill the hole with a suitable product and cover with paint</li>
                    </ul>
                    <p>Further advice on the drying out process can be found in the homeowner&rsquo;s manual uploaded to your document library after legal completion &#40;where applicable&#41;.</p>"
    DefaultFaq.where(answer: bath_old)
              .update(answer: bath_updated)
    Faq.where(answer: bath_old)
       .update(answer: bath_updated)

    # Why are screw/nail heads starting to show in the plastered surfaces?
    screw_old = "<p>The materials that were used to build your new home contained a lot of water. This water will take around 6–18 months to evaporate completely, which is known as the drying out process. During this time, the plasterwork in your home may shrink slightly, causing some small changes to occur. One of the changes is that nail or screw heads may pop out of plastered finishes and will need to be hammered or screwed down. The hole can then be filled with a suitable product and covered with paint.</p>\n\n  <p>Below is a list of the other common signs of drying out and simple steps you can take to deal with them:</p>\n\n  <ul>\n  \t<li>Small shrinkage cracks may appear in plastered finishes. These can be filled using a suitable product and covered with paint</li>\n  \t<li>Baths and shower trays may drop very slightly. You should reseal them around the edges with a silicone sealant</li>\n  \t<li>Wooden door frames and windows may move. Simply adjust the door or window keep if necessary</li>\n  </ul>\n\n  <p>Further advice on the drying out process can be found in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    screw_updated = "<p>The materials that were used to build your new home contained a lot of water. This water will take around 6–18 months to evaporate completely, which is known as the drying out process. During this time, the plasterwork in your home may shrink slightly, causing some small changes to occur. One of the changes is that nail or screw heads may pop out of plastered finishes and will need to be hammered or screwed down. The hole can then be filled with a suitable product and covered with paint.</p>
                     <p>Below is a list of the other common signs of drying out and simple steps you can take to deal with them:</p>
                       <ul>
                         <li>Small shrinkage cracks may appear in plastered finishes. These can be filled using a suitable product and covered with paint</li>
                         <li>Baths and shower trays may drop very slightly. You should reseal them around the edges with a silicone sealant</li>
                         <li>Wooden door frames and windows may move. Simply adjust the door or window keep if necessary</li>
                       </ul>
                     <p>Further advice on the drying out process can be found in the homeowner&rsquo;s manual uploaded to your document library after legal completion &#40;where applicable&#41;.</p>"
    DefaultFaq.where(answer: screw_old)
              .update(answer: screw_updated)
    Faq.where(answer: screw_old)
       .update(answer: screw_updated)

    # How can I reduce condensation in my home?
    condensation_old = "<p>Condensation is steam or water vapour, which reverts to water on contact with a cold surface. There are a few steps you can take to reduce condensation in your home:</p>\n\n  <ul>\n  \t<li>Stop moisture from spreading by closing kitchen and bathroom doors when cooking, showering or bathing</li>\n  \t<li>Cover pans when cooking</li>\n  \t<li>Use extractor fans and ventilation systems</li>\n  \t<li>Open windows when possible and leave trickle vents open at all times (where fitted). Or, if you have a whole house ventilation system, leave windows and trickle vents closed, and keep your system running constantly</li>\n  \t<li>Leave internal and wardrobe doors (except fire doors) open when possible</li>\n  </ul>\n\n  <p>Despite taking these steps, condensation may still occur. Simply wipe the affected surface with a dry cloth to prevent moisture from soaking into finishes. Further information may be available in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    condensation_updated = "<p>Condensation is steam or water vapour, which reverts to water on contact with a cold surface. There are a few steps you can take to reduce condensation in your home:</p>
                            <ul>
                              <li>Stop moisture from spreading by closing kitchen and bathroom doors when cooking, showering or bathing</li>
                              <li>Cover pans when cooking</li>
                              <li>Use extractor fans and ventilation systems</li>
                              <li>Open windows when possible and leave trickle vents open at all times (where fitted). Or, if you have a whole house ventilation system, leave windows and trickle vents closed, and keep your system running constantly</li>
                              <li>Leave internal and wardrobe doors (except fire doors) open when possible</li>
                            </ul>
                            <p>Despite taking these steps, condensation may still occur. Simply wipe the affected surface with a dry cloth to prevent moisture from soaking into finishes. Further information can be found in the homeowner&rsquo;s manual uploaded to your document library after legal completion &#40;where applicable&#41;.</p>"
    DefaultFaq.where(answer: condensation_old)
              .update(answer: condensation_updated)
    Faq.where(answer: condensation_old)
       .update(answer: condensation_updated)

    # Will my new utility companies already have my details?
    utility_old = "<p>We have advised the utility companies supplying your property that we no longer own your home but you will need to call them separately to register your details. You will also need to supply your meter readings from the day you moved in.</p>\n\n  <p>You will find contact details for your utility suppliers in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    utility_updated = "<p>We have advised the utility companies supplying your property that we no longer own your home but you will need to call them separately to register your details. You will also need to supply your meter readings from the day you moved in.</p>
                       <p>After legal completion, you will find contact details for your utility suppliers in the contacts section of this website.</p>"
    DefaultFaq.where(answer: utility_old)
              .update(answer: utility_updated)
    Faq.where(answer: utility_old)
       .update(answer: utility_updated)

    # Does my local authority have my details?
    DefaultFaq.where(answer: "<p>You will need to contact your local authority to provide your details and set up your council tax payments. You can find their details in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  ")
              .update(answer: "<p>You will need to contact your local authority to provide your details and set up your council tax payments. After legal completion, you can find their contact information in the contacts section of this website.</p>")
    Faq.where(answer: "<p>You will need to contact your local authority to provide your details and set up your council tax payments. You can find their details in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  ")
       .update(answer: "<p>You will need to contact your local authority to provide your details and set up your council tax payments. After legal completion, you can find their contact information in the contacts section of this website.</p>")

    # What should I do if I smell gas?
    gas_old = "<ul>\n  \t<li>Don&rsquo;t smoke or light matches&nbsp;</li>\n  \t<li>Don&rsquo;t turn electrical switches on or off, including doorbells and light switches&nbsp;</li>\n  \t<li>Open doors and windows&nbsp;</li>\n  \t<li>Turn off the meter at the control valve (unless it is in a confined space and you&rsquo;re putting yourself at risk)</li>\n  \t<li>Call the free 24 hour National Gas Emergency helpline on 0800 111 999</li>\n  </ul>\n  "
    gas_updated = "<ul>
                     <li>Don&rsquo;t smoke or light matches&nbsp;</li>
                     <li>Don&rsquo;t turn electrical switches on or off, including doorbells and light switches&nbsp;</li>
                     <li>Open doors and windows&nbsp;</li>
                     <li>Turn off the meter at the control valve (unless it is in a confined space and you&rsquo;re putting yourself at risk)</li>
                     <li>Call the free 24 hour national gas emergency helpline on 0800 111 999</li>
                   </ul>"
    DefaultFaq.where(answer: gas_old)
              .update(answer: gas_updated)
    Faq.where(answer: gas_old)
       .update(answer: gas_updated)

    # Who should I contact if I have an urgent problem with my new home?
    DefaultFaq.where(answer: "<p>Please consult the advice contained in your homeowner&rsquo;s manual and get in touch with any emergency contacts provided. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  ")
              .update(answer: "<p>Please consult the advice contained in your homeowner&rsquo;s manual (where applicable) and get in touch with any emergency contacts provided. After legal completion, you can find contact information in the contacts section of this website.</p>")
    Faq.where(answer: "<p>Please consult the advice contained in your homeowner&rsquo;s manual and get in touch with any emergency contacts provided. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  ")
       .update(answer: "<p>Please consult the advice contained in your homeowner&rsquo;s manual (where applicable) and get in touch with any emergency contacts provided. After legal completion, you can find contact information in the contacts section of this website.</p>")

    # There&rsquo;s damage to my roof. What should I do?
    roof_old = "<p>If you live in a freehold property, and the damage is as a result of bad weather conditions, please contact your insurance company. If you live in a leasehold property, and the damage is as a result of bad weather conditions, please contact your managing agent or landlord. For other roofing issues, please see the advice contained in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    roof_updated ="<p>If you live in a freehold property, and the damage is as a result of bad weather conditions, please contact your insurance company.
                      If you live in a leasehold property, and the damage is as a result of bad weather conditions, please contact your managing agent or landlord. For other roofing issues, please see the advice contained in your homeowner&rsquo;s manual (where applicable).</p>"
    DefaultFaq.where(answer: roof_old)
              .update(answer: roof_updated)
    Faq.where(answer: roof_old)
       .update(answer: roof_updated)

    # Why has an MCB tripped?
    mcb_old = "<p>A miniature circuit breaker (MCB) on your consumer unit usually trips either because a light bulb has blown or a faulty appliance has overloaded the circuit or caused a short circuit somewhere in the system.&nbsp; Instead of just switching the MCB back on:</p>\n\n  <ul>\n  \t<li>Go to your consumer unit and identify which circuit has been affected; the relevant MCB will be in the &lsquo;off&rsquo; position</li>\n  \t<li>Disconnect (rather than just switch off) any appliances on this circuit</li>\n  \t<li>Switch the MCB back on to restore the circuit</li>\n  \t<li>Reconnect the appliances in turn and see if the MCB fuses again.&nbsp; If it does, this will show which is the faulty appliance</li>\n  </ul>\n\n  <p>If you can&rsquo;t find the fault, please call an electrician.</p>\n\n  <p>It is important to note that some faults are intermittent and everything may work for a short time.&nbsp; In this case, don&rsquo;t keep switching the MCB and instead call a suitably qualified electrician to correct the fault.</p>\n  "
    mcb_updated = "<p>A miniature circuit breaker (MCB) on your consumer unit usually trips either because a light bulb has blown or a faulty appliance has overloaded the circuit or caused a short circuit somewhere in the system.&nbsp; Instead of just switching the MCB back on:</p>
                   <ul>
                     <li>Go to your consumer unit and identify which circuit has been affected; the relevant MCB will be in the &lsquo;off&rsquo; position</li>
                     <li>Disconnect (rather than just switch off) any appliances on this circuit</li>
                     <li>Switch the MCB back on to restore the circuit</li>
                     <li>Reconnect the appliances in turn and see if the MCB fuses again.&nbsp; If it does, this will show which is the faulty appliance</li>
                   </ul>
                   <p>If you can&rsquo;t find the fault, please call an electrician.</p>
                   <p>It is important to note that some faults are intermittent and everything may work for a short time.&nbsp; In this case, don&rsquo;t keep switching the MCB and instead call a suitable qualified electrician to correct the fault.</p>"
    DefaultFaq.where(answer: mcb_old)
              .update(answer: mcb_updated)
    Faq.where(answer: mcb_old)
       .update(answer: mcb_updated)

    # I have no power or water. What should I do?
    power_old = "\n  <ul>\n    <li>Check with your neighbours to see if they are also affected</li>\n    <li>Contact the managing agent (if applicable) to check whether this loss of supply is due to local maintenance works</li>\n    <li>If a loss of power is confined to your home, check whether an MCB has tripped on your consumer unit (please see ‘Why has an MCB tripped?&rsquo;)</li>\n    <li>If your home&rsquo;s electrical system or water system fails soon after legal completion, the developer may be liable. Consult your homeowner&rsquo;s manual for details of the developer&rsquo;s liability period and then get in touch with your developer&rsquo;s customer care team. After legal completion, you can view or download a PDF file of this manual in the document library on this website</li>\n    <li>If the developer is not liable, contact a qualified electrician or plumber</li>\n    <li>Report a local power cut to your area&rsquo;s electricity network operator – dial 105 and you will be put through to the local contact</li>\n    <li>Report a loss of water supply to your water supplier – most have a 24 hour line for supply or drainage emergencies</li>\n    <li>If you need to flush a toilet without any water supply, pour half a bucket of water down it to flush it manually</li>\n  </ul>\n  "
    power_updated = "<ul>
                       <li>Check with your neighbours to see if they are also affected</li>
                       <li>Contact the managing agent (if applicable) to check whether this loss of supply is due to local maintenance works</li>
                       <li>If a loss of power is confined to your home, check whether an MCB has tripped on your consumer unit (please see ‘Why has an MCB tripped?&rsquo;)</li>
                       <li>If your home&rsquo;s electrical system or water system fails soon after legal completion, the developer may be liable. Consult your homeowner&rsquo;s manual (where applicable) for details of the developer&rsquo;s liability period and then get in touch with your developer&rsquo;s customer care team.</li>
                       <li>If the developer is not liable, contact a qualified electrician or plumber</li>
                       <li>Report a local power cut to your area&rsquo;s electricity network operator – dial 105 and you will be put through to the local contact</li>
                       <li>Report a loss of water supply to your water supplier – most have a 24 hour line for supply or drainage emergencies</li>
                       <li>If you need to flush a toilet without any water supply, pour half a bucket of water down it to flush it manually</li>
                     </ul>"
    DefaultFaq.where(answer: power_old)
              .update(answer: power_updated)
    Faq.where(answer: power_old)
       .update(answer: power_updated)

    # What should I do if I have no heating or hot water?
    heating_old = "<p>First check the following:</p>\n\n  <ul>\n  \t<li>The timer is programmed correctly (where applicable), with accurate time and date and no active override settings</li>\n  \t<li>You have allowed enough time for the system to heat up</li>\n  </ul>\n\n  <p>Please note, during the winter, there may be a warm-up period of at least 60 minutes before the effects of any heating will be noticed.</p>\n\n  <p>In the event of a heating system breakdown, please consult your homeowner&rsquo;s manual for further advice, as the developer may be liable for issues occurring shortly after legal completion. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    heating_updated = "<p>First check the following:</p>
                       <ul>
                         <li>The timer is programmed correctly (where applicable), with accurate time and date and no active override settings</li>
                         <li>You have allowed enough time for the system to heat up</li>
                       </ul>
                       <p>Please note, during the winter, there may be a warm-up period of at least 60 minutes before the effects of any heating will be noticed.</p>
                       <p>In the event of a heating system breakdown, please consult your documentation for further advice, as the developer may be liable for issues occurring shortly after legal completion. Where applicable, this information can be found in the homeowner&rsquo;s manual uploaded to your document library after legal completion.</p>"
    DefaultFaq.where(answer: heating_old)
              .update(answer: heating_updated)
    Faq.where(answer: heating_old)
       .update(answer: heating_updated)

    # My radiator is not heating properly. What should I do?
    radiator_old = "<p>If you experience a radiator failing to heat this could be an indication of air in the system.&nbsp; This is a common problem, particularly in newly installed heating systems.&nbsp; In this instance, you should follow the steps below:</p>\n\n  <ul>\n  \t<li>To release the air, attach a radiator bleeding key to the bleed valve and turn it anticlockwise.&nbsp; This should be done gently to avoid the valve being removed completely</li>\n  \t<li>Open the valve until a hissing sound can be heard; this will indicate that the air is escaping.&nbsp; Hold a cloth beneath the valve to protect both the floor surface and your hands from any hot water that escapes</li>\n  \t<li>When water starts to escape from the radiator, close the bleed valve by turning it clockwise</li>\n  </ul>\n  "
    radiator_updated = "<p>If you experience a radiator failing to heat this could be an indication of air in the system.&nbsp; This is a common problem, particularly in newly installed heating systems.&nbsp; In this instance you should follow the steps below:</p>
                        <ul>
                          <li>To release the air, attach a radiator bleeding key to the bleed valve and turn it anticlockwise.&nbsp; This should be done gently to avoid the valve being removed completely</li>
                          <li>Open the valve until a hissing sound can be heard; this will indicate that the air is escaping.&nbsp; Hold a cloth beneath the valve to protect both the floor surface and your hands from any hot water that escapes</li>
                          <li>When water starts to escape from the radiator close the bleed valve by turning it clockwise</li>
                        </ul>"
    DefaultFaq.where(answer: radiator_old)
              .update(answer: radiator_updated)
    Faq.where(answer: radiator_old)
       .update(answer: radiator_updated)

    # I have heated towel rails – why does my bathroom feel cold?
    DefaultFaq.where(answer: "<p>If heated towel rails have been installed, they may be there not only to warm towels but also to heat the room.&nbsp; If your bathroom feels cold, it might be because you&rsquo;ve completely covered your rails with towels.</p>\n  ")
              .update(answer: "<p>If heated towel rails have been installed, they may be there not only to warm towels but also to heat the room.&nbsp; If your bathroom feels cold it might be because you&rsquo;ve completely covered your rails with towels.</p>")
    Faq.where(answer: "<p>If heated towel rails have been installed, they may be there not only to warm towels but also to heat the room.&nbsp; If your bathroom feels cold, it might be because you&rsquo;ve completely covered your rails with towels.</p>\n  ")
       .update(answer: "<p>If heated towel rails have been installed, they may be there not only to warm towels but also to heat the room.&nbsp; If your bathroom feels cold it might be because you&rsquo;ve completely covered your rails with towels.</p>")

    # I have spotted a water leak. What should I do?
    leak_old = "<p>Any leak that appears, however small, should be reported to your water supplier at your earliest convenience so that it can be rectified before it escalates into a more serious problem. Details of your water supplier can be found in your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n\n  <p>If water is leaking within your home, turn off the supply at the stop tap or use buckets or towels to keep the water contained. You may find advice on who to contact within your homeowner&rsquo;s manual. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    leak_updated = "<p>Any leak that appears, however small, should be reported to your water supplier at your earliest convenience so that it can be rectified before it escalates into a more serious problem. Details of your water supplier can be found in the contacts section of this website.</p>
                    <p>If water is leaking within your home, turn off the supply at the stop tap or use buckets or towels to keep the water contained. You will find advice on who to contact in the contacts section of this website.</p>"
    DefaultFaq.where(answer: leak_old)
              .update(answer: leak_updated)
    Faq.where(answer: leak_old)
       .update(answer: leak_updated)

    # Why is water draining slowly in my kitchen/bathroom?
    draining_old = "<p>Slow draining water, or water that is not draining at all, indicates a blockage. To clear a blockage:</p>\n\n  <ul>\n  \t<li>Try using a flexible rod or plunger/suction cup to remove it</li>\n  \t<li>If a plunger doesn&rsquo;t work, pour in a drain cleaner. Make sure you follow the manufacturer&rsquo;s instructions on any drain cleaning product</li>\n  \t<li>If you try to remove a blockage from a sink by hand, please wear gloves to protect your hands and place a bucket under the sink trap. Unscrew the trap, reach in and remove the blockage, then screw the trap back into place</li>\n  \t<li>For serious plumbing issues, please contact a plumber</li>\n  </ul>\n\n  <p>To help prevent blockages:</p>\n\n  <ul>\n    <li>Don&rsquo;t empty large quantities of bleach or similar cleaning agents into the system</li>\n    <li>Don&rsquo;t empty cooking oil or anything similar down the sink</li>\n    <li>Don&rsquo;t put anything other than toilet paper down your WC</li>\n    <li>Don&rsquo;t use excess washing powder in your washing machine</li>\n    <li>Regularly remove hairs that get trapped in the basin/bath/shower plughole</li>\n    <li>Use a plughole protector to prevent sink blockages</li>\n  </ul>\n  "
    draining_updated = "<p>Slow draining water, or water that is not draining at all, indicates a blockage.</p>
                        <p>To clear a blockage:</p>
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
    DefaultFaq.where(answer: draining_old)
              .update(answer: draining_updated)
    Faq.where(answer: draining_old)
       .update(answer: draining_updated)

    # Where can I find information on how to look after my home&rsquo;s finishes and fittings?
    fittings_old ="<p>Some advice on how to care for the finishes that may have been installed within your home has been provided in this section.</p>\n\n  <p>Please see your homeowner&rsquo;s manual for further advice on how to care for your home&rsquo;s finishes and fittings. After legal completion, you can view or download a PDF file of this manual in the document library on this website.</p>\n  "
    fittings_updated = "<p>Some advice on how to care for the finishes that may have been installed within your home has been provided in this section.</p>
                        <p>Further advice on how to care for your home&rsquo;s finishes and fittings can be found in the homeowner&rsquo;s manual uploaded to your document library after legal completion (where applicable).</p>"
    DefaultFaq.where(answer: fittings_old)
              .update(answer: fittings_updated)
    Faq.where(answer: fittings_old)
       .update(answer: fittings_updated)

    # How can I protect my new carpet?
    carpet_old = "<p>You should vacuum your carpet regularly in order to remove dirt and grit.&nbsp; Any stains should be treated as quickly as possible, blotting the area, not rubbing.&nbsp; For large or persistent stains, you should call a professional carpet cleaner.</p>\n  "
    carpet_updated = "<p>You should vacuum your carpet regularly in order to remove dirt and grit.&nbsp; Any stains should be treated as quickly as possible, blotting the area not rubbing.&nbsp; For large and persistent stains you should call a professional carpet cleaner.</p>"
    DefaultFaq.where(answer: carpet_old)
              .update(answer: carpet_updated)
    Faq.where(answer: carpet_old)
       .update(answer: carpet_updated)

    # Can I cover my air bricks?
    bricks_old = "<p>If your home has a suspended ground floor, you will find air bricks outside at low level to provide ventilation.&nbsp; Please ensure that no rubbish, garden material or soil covers the damp-proof course or air bricks.&nbsp; Soil and paving or patio material should be kept a minimum of 150mm or two brick courses below the damp-proof course.</p>\n  "
    bricks_updated = "<p>If your home has a suspended ground floor you will find air bricks outside at low level to provide ventilation.&nbsp; Please ensure that no rubbish, garden material or soil covers the damp proof course or air bricks.&nbsp; Soil and paving or patio material should be kept a minimum of 150mm or two brick courses below the damp proof course.</p>"
    DefaultFaq.where(answer: bricks_old)
              .update(answer: bricks_updated)
    Faq.where(answer: bricks_old)
       .update(answer: bricks_updated)

    # What steps can I take to save energy and water?
    energy_old = "<p>To reduce your energy use:</p>\n  <ul>\n  \t<li>Don&rsquo;t set your heating thermostat higher than necessary; turning your heating settings down by 1°C will reduce your energy consumption and your heating bills</li>\n    <li>Programme your heating and hot water to only turn on at the times you need it</li>\n    <li>Wait until you have a full load before using your washing machine or dishwasher</li>\n    <li>Where possible, allow clothes to dry naturally rather than using a tumble dryer</li>\n    <li>Let food cool down before putting it in the fridge or freezer</li>\n    <li>Switch lights off when you don&rsquo;t need them</li>\n    <li>Use energy saving light bulbs</li>\n    <li>Use “economy” settings on your appliances and turn them off when not in use, instead of leaving them on standby</li>\n    <li>If buying a new boiler or kitchen appliance in the future, choose one with a higher energy efficiency rating</li>\n    <li>Unplug portable devices once they are fully charged</li>\n    <li>Run your washing machine at 30°C; most washing detergents are specially designed to work well at low temperatures</li>\n    <li>Match pan size to ring size and cover pans so that the contents heat up more quickly</li>\n  </ul>\n\n  <p>To reduce your water consumption:</p>\n\n  <ul>\n    <li>Repair dripping taps</li>\n    <li>Only fill the kettle with the amount of water you need</li>\n    <li>Have a shower instead of a bath</li>\n    <li>Use a save-a-flush bag in your toilet cistern</li>\n    <li>Don&rsquo;t leave the tap running while brushing your teeth or shaving</li>\n    <li>Wash your car using a bucket and sponge, rather than a hose</li>\n    <li>Wash your fruit and vegetables in a bowl rather than under a running tap</li>\n    <li>Put a jug of water in the fridge, instead of running the tap until the water is cold</li>\n    <li>If you have a garden, water it in the morning or evening, when the temperature is lower so less water will evaporate</li>\n    <li>Reuse washing up water for your houseplants or garden</li>\n  </ul>\n  "
    energy_updated = "<p>To reduce your energy use:</p>
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
                        <li>Match pan size to ring size and cover pans so that the contents heat up quicker</li>
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
    DefaultFaq.where(answer: energy_old)
              .update(answer: energy_updated)
    Faq.where(answer: energy_old)
       .update(answer: energy_updated)
  end

  def down
    # no changes
  end
end
