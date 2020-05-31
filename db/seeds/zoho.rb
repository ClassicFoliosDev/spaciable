
bovis = Developer.find_by(company_name: "Bovis")
Crm.create(developer: bovis,
           name: "Zoho",
           client_id: "1000.TP2FIRVLU0SC4K0QO1KNK6V1ND1J7R",
           client_secret: "03d1bbb0bd8cec84738fc2132742dc671dd3e28ebc",
           redirect_uri: "https://spaciable.ngrok.io/zoho/callback",
           current_user_email: "Accounts@classicfolios.com",
           accounts_url: "https://accounts.zoho.eu",
           api_base_url: "https://www.zohoapis.eu",
           token_persistence_path: "/home/classic")
