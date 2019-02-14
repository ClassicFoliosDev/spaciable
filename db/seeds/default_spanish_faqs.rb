# coding: utf-8

# After pasting these into a developer's FAQs locally this file was generated in the rails console with:
# ```
# developer = Developer.find_by(name: "The Developer")
# faqs = developer.faqs.order(created_at: :asc).map do |f|
#   %({\r\n\  question: %(#{f.question}),\r\n\  answer: %(#{f.answer}),\r\n  category: %(#{f.category})\r\n})
# end;
# File.open(Rails.root + "db/seeds/faqs.rb", "wb+") { |f| f.write("[" + faqs.join(", ") + "]") }
# ```

Spain_ID = Country.find_by(name: "Spain").id

[{
  question: %(Who can own property in Spain?),
  answer: %(<p>Both Spanish nationals and internationals can buy property in Spain.</p>

<p>There are no restrictions on whether the property is residential, commercial or just land.</p>

<p>The purchasing process, however, needs to be understood and followed, and important aspects of this process are contained in these FAQs.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(Should I buy as an individual or as a company?),
  answer: %(<p>This is a complex question and there is often conflicting advice on the matter. You should consider all your options fully before committing to any course. For example, if buying as a company, there is the question of whether the company should be Spanish, British or based offshore. The natural inference of “offshore” is that there are potential tax savings, but the Spanish authorities have become very vigilant on this subject and they have a blacklist of countries and territories that are not permitted in Spain.</p>

<p>As an individual buyer, one question to ask is whether a group of individuals should buy together, including, for instance, those who are not related by family. This is a complex question needing specialist legal advice, but a few aspects that should be considered are:</p>

<ul>
  <li> What happens if one of the group wants to sell and the others don’t?</li>

  <li>If the group has agreed to sell, what measures have you put in place to agree upon the selling price?<li>

  <li>What happens if one of the group dies? Is there a will to cover this eventuality? If there is a will, do the provisions allow for the beneficiaries of the estate to continue as owners, or to sell it?</li>
</ul>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(What is a Spanish NIE and do I need one?),
  answer: %(<p>An NIE (número de identidad de extranjero) is a Spanish tax number for non-residents of Spain. This number is unique to you.<p>

<p>You need to have an NIE in place in order to be involved in any official process in Spain, such as buying a property, buying a car, getting your property connected to utilities and for paying taxes.</p>

<p>If you are buying a property in Spain, it is essential that you have your NIE in place in order to complete the purchase.  You can apply for an NIE in person, either at the local police station in Spain or, for example, at the Spanish Consulate in London.</p>

<p>Alternatively, you can apply for an NIE through a lawyer (abogado or abogada). Since it is rare that the purchaser will be in a position to make regular trips to Spain, it is usual for the lawyer to be granted Power of Attorney to carry out certain tasks on the purchaser’s behalf - and one of these is to obtain an NIE. You will receive a certificate with your number on it.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(Do I need a Spanish bank account?),
  answer: %(<p>You will almost certainly need a Spanish bank account to complete your purchase.</p>

<p>You may choose to do this yourself, so that funds can be sent over to that account for the purpose of depositing the funds required for the purchase of your property in Spain.</p>

<p>However, if you are arranging a Spanish mortgage for part of the purchase price, you will be expected to have an account with the same bank. If you can, avoid opening two accounts because monthly charges will apply and it will cost you more.</p>

<p>Your Spanish lawyer can also open a Spanish bank account for you. If you decide not to use a Spanish bank account, there will be stringent anti- money laundering checks in place. It is important that the source of the funds is clear and that the required documentation is provided to the notary office. </p>

<p>Additionally, when you own a property in Spain, you will need to pay for utilities and services to your property and this is impractical, even impossible, from an overseas bank account. It is therefore important for you to have a Spanish bank account as early as possible.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(What is the process of buying a property in Spain?),
  answer: %(<p>You have the choice of buying a new build or a property for resale. If you buy a new property, there are two options available.</p>

<p>OFF-PLAN:</p>

<p>This is where you will secure the potential purchase of a property by firstly paying a deposit – often €3,000 or €6,000 – then making a series of further payments as the building of your property progresses.<p>

<p>This can sound risky, but there are a number of safeguards in Spain to protect any funds you pay. After your initial deposit, your off-plan purchase will usually involve a number of stage payments, culminating in a final payment from your own funds or by way of a mortgage.</p>

<p>You have the legal right to an “aval”, which is a financial guarantee provided to you either by a Spanish-registered bank or by an insurance company, registered and regulated in Spain.<p>

<p>The “aval” will protect all your various stage payments against the non-performance of the contract, e.g., if the property is not built and/or if the builder goes bankrupt.</p>

<p>The “aval” ceases to have validity when the purchase is completed at the notary office and you are the registered owner of the property.</p>

<p>KEY-READY:</p>

<p>This means that your property is already completed, so you will normally pay a percentage of the purchase price to reserve that particular property. You can then complete the purchase either with all further payments coming from your own resources, or partially with the help of a Spanish mortgage, or funding from other sources.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(What is a notary and what do they do?),
  answer: %(<p>A notary is a public official who processes property agreements in order for them to be ratified and entered into Land Registry. The notary will charge fees for their service, but buying a property is not possible without one.</p>

<p>At the meeting with the notary, where the purchase is completed and ratified, all parties to the purchase/sale need to be present, or represented officially by a party (usually your lawyer) with a properly regularised Power of Attorney.</p>

<p>The notary plays a neutral role and their job is to ensure that the agreement is understood by both parties, is legal and that all taxes are paid. It is, therefore, important to have legal representation, usually by an independent, fully- qualified Spanish lawyer, whose role is to advise you in your best interests.</p>

<p>The notary will read out all the salient parts of the purchase contract and, upon agreement of all parties, will pass the document(s) round for signing.</p>

<p>If you have taken out a Spanish mortgage, this deed will also be signed by the notary and fees will be paid on the mortgage document.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(How long does it take to buy a property in Spain?),
  answer: %(<p>The timescale to complete the purchase can vary considerably. This can depend upon whether the property is already complete when your purchase process begins.<p>

<p>If the property is immediately available, it can often take between four to six weeks from acceptance of the offer to completion of the transaction. However, if you are using a Spanish mortgage as part of the purchase, the timescale can be considerably longer because the administration system of several of the Spanish banks can be very slow. Final decisions are often made via their “risk department”, where security checks take place.</p>

<p>It will also depend on whether you are negotiating the mortgage yourself or if you are arranging it through an independent mortgage broker.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(Is the property I buy in Spain freehold or leasehold?),
  answer: %(<p>The concepts of freehold and leasehold do not exist in Spain.  If you buy a property, and pay all taxes, then you own it outright.  If you buy a house, then you also own the land that the house sits upon.  If you buy an apartment, then you own the walls, the ceiling and the floor, as well as the terraces.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(How much does it cost to buy a property in Spain?),
  answer: %(<p>All purchase of property in Spain, whether new or resale, is subject to purchase tax. There are also other costs to be aware of.</p>

<ul>
  <li>Notary fees have to be paid because the notary system is the means by which your property purchase is properly registered. If you take out a mortgage on the property, the mortgage document will also be registered at the notary, so there will be fees payable on that document too.</li>

  <li>If you are purchasing a new property, or a property off-plan, then you will pay Spanish VAT (IVA) – currently 10% of the purchase price (7% in the Canary Islands), and 1.5% in relation to purchase tax (1% in the Canary Islands)</li>

  <li>If it is a resale, the purchase tax is in fact “ITP” (Impuesto Transmisiones Patrimoniales), which is a transfer tax. The rate of tax varies from region to region</li>

  <li>Stamp duty is paid alongside VAT on new properties</li>

  <li>In addition, you will need to allow for legal fees</li>
</ul>

<p>You will have to think about whether or not the property is furnished. Some new build properties include a furniture package, which can be an invaluable aid.</p>

<p><b>N.B.</b> With regard to Spanish mortgages, please note that legislation late in 2018 passed by the Spanish government countermanded the judgement of the Spanish Supreme Court itself. This resulted in some of the notary fees now being paid by the lending bank itself, and not the purchaser taking out the mortgage.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(What other costs do I have when I own a property in Spain?),
  answer: %(<p>Some costs are similar to charges you will pay on a property in your own country where you are a resident.</p>

<p>For example, you will have the cost of the usual utilities, e.g., water and electricity. These are easily paid by direct debit through your Spanish bank account.  These are almost impossible to pay through a non-Spanish bank account.</p>

<p>If you buy an apartment, townhouse or villa with communal areas, you will have to pay community fees.  These are the fees associated with the maintenance of the common parts of the development. Community fees are difficult to estimate before a development is finished. They work on the basis of an elected committee, in which all property owners vote.</p>

<p>The level of the fees also depends on the extent of the communal areas in question. For example, if you buy a property on a golf and leisure resort, there can be extensive communal areas. This may or may not include the golf course itself, depending on whether the management of the course is an integral part of the resort, or whether the course is under the ownership of or subject to a lease arrangement with an independent company.</p>

<p>Typically, in an urban development with a communal swimming pool and surrounding plants, the fees can be as little as €30 a month.</p>
 
<p>All property owners in Spain are liable to pay IBI (Impuesto sobre Bienes Inmuebles), a local municipal tax similar to council tax. The cost varies greatly from one municipality to another, so depends upon the location and also the type of property. The amount can generally vary from around €50 to a few hundred. </p>

<p>As a non-resident property owner in Spain, you will need to pay non-resident’s income tax on an annual basis.  This is a tax that is based upon the rateable value of your property.</p>

<p>If you rent out the property, then you must also pay tax on the rental income generated. Rental can be ad hoc, short-term or long-term and you may choose to do it yourself or through a management company. There is legislation in place in different regions regarding licensing, which you should be familiar with. Renting through Airbnb is illegal in some parts of Spain.</p>
),
  category: %(general),
  country_id: Spain_ID
}, {
  question: %(Do I need to make a Spanish will if I own a property in Spain?),
  answer: %(<p>It is not compulsory to have a Spanish will, but it can make matters simpler in the unfortunate circumstances of the owner(s) dying.</p>

<p>At the very least, it is essential to have an up-to-date will in the country where you are a citizen and/or resident, but in Spain it is also important to explain with total clarity your intentions regarding your Spanish assets:</p>

<ul>
  <li>The will in Spain saves the dilemma of having an official translation into Spanish</p>

  <li>The Spanish will can specifically relate to just the Spanish assets that you have, including your Spanish property, bank account balance, etc.</li>
</ul>

<p>Stating your explicit intentions in your Spanish will is important because the law of succession in Spain is very different to the equivalent, for example, in the UK. If you have not made it clear in your will how you would like your assets distributed, the law automatically makes provision for them to go to your spouse and children in the first instance.<p>

<p>If you have made your will in Spain, it has to be signed at the notary office. From there, it will be sent to the central office in Madrid, where it will be registered. There is an additional cost for this service.</p>
),
  category: %(general),
  country_id: Spain_ID
}, {
  question: %(Should I have a Spanish mortgage?),
  answer: %(<p>This is very much a personal decision. You should take independent, specialised advice and consider all of your options first before taking out a mortgage.</p>

<p>Some options available are:</p>

<ul>
  <li>Mortgage or remortgage on your UK residence or other properties, including buy-to-let properties</li>

  <li>Equity release</li>

  <li>Mortgage taken out with a Spanish or international bank. Spanish banks lend to internationals very widely. Such mortgages are now available on a “full status basis”, i.e., the borrower has to make a full and detailed disclosure of assets and liabilities, including copies of a UK credit report</p>
</ul>

<p>For a Spanish mortgage, you should bear in mind:</p>

<ul>

  <li>You will need a deposit of at least 30% of the property’s purchase price</li>

  <li>The maximum mortgage for non-residents is 70% of the purchase price or valuation; this can even be a maximum of 60% with some banks</li>

  <li>In addition, you will need to finance 100% of the additional notary’s costs (including their fees, stamp duty, land registry costs, etc.) because the bank will not cover all or any part of these</li>

  <li>Rates are normally based on a margin of “X%” above the Euribor Index (Euro Interbank Offered Rate), which is the most preferential rate</li>

  <li>If mortgages are offered not using the Euribor Index, they can be much more expensive. Some are based on the average of mortgage rates offered by a cross-section of banks in Spain</li>

  <li>Variable rates and fixed rates are available. The fixed rates are often available for the full term of the mortgage</li>
</ul>
<p>As a purchaser, you can approach a Spanish bank directly or use the services of mortgage advisors.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(What is the ten year building guarantee and what does it cover?),
  answer: %(<p>This is a guarantee that the developer is legally obliged to give you, the purchaser, when you buy a new property.</p>

<p>This seguro decenal is an insurance policy provided by a third party that has already been paid for by the developer. It covers structural faults within the first ten years of a new build property.</p>

<p>It is a valuable asset and, if you resell the property within the ten year period, the remaining cover transfers to the new owner.</p>
),
  category: %(purchasing),
  country_id: Spain_ID
}, {
  question: %(How often can I visit my property?),
  answer: %(<p>If you are an international:</p>

<p>If you are not a resident of Spain, entry into the country is regulated on the basis that your stay must not exceed 90 days in any 180 day period.</p>

<p>If you are a member of the EU, or are a resident of Switzerland, Norway, Iceland or Liechtenstein, the only requirement is a valid national identity document or passport.</p>

<p>Citizens of the UK and Ireland will already require a passport because their countries are not members of the Schengen Area.</p>

<p>There is then a long list of countries, including USA, Canada and South and Central American countries, who do not need a visa. A valid passport grants visits on a term not exceeding 90 days in any 180 day period.</p>

<p>If you are a Spanish resident:</p>

<p>There are various regulations that apply to both EU and non-EU citizens, which should be properly researched. These relate to residences that are valid for over 90 days but less than 5 years, and also those that are valid for more than 5 years.</p>

<p><b>N.B.</b> Entry to Spain has worked very smoothly for many years for both EU and non-EU citizens, for both short-term visits and for residency purposes.</p>
),
  category: %(general),
  country_id: Spain_ID
}].each do |attrs|
  faq = DefaultFaq.find_or_initialize_by(attrs)

  next unless faq.new_record?

  if faq.save
    puts "Added Default Spanish Faq: #{faq.question}"
  else
    puts "Error adding default FAQ: #{attrs[:question]} -- #{faq.errors.full_messages}"
  end
end
