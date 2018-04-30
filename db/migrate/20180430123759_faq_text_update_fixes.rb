class FaqTextUpdateFixes < ActiveRecord::Migration[5.0]
  def up
    puts "============"
    puts "Migrating FAQ MCB text contents"

    mcb_answer = "<p>A miniature circuit breaker (MCB) on your consumer unit usually trips either because a light bulb has blown or a faulty appliance has overloaded the circuit or caused a short circuit somewhere in the system.&nbsp; Instead of just switching the MCB back on:</p>

    <ul>
	    <li>Go to your consumer unit and identify which circuit has been affected; the relevant MCB will be in the &lsquo;off&rsquo; position</li>
	    <li>Disconnect (rather than just switch off) any appliances on this circuit</li>
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


    puts "Finished updating FAQ MCB text contents"
    puts "================"
  end

  def down
    # No reverse for these text content changes, to change the text again, migrate forward
  end
end
