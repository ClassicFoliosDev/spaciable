Rails.configuration.mailchimp = {
  subscribed: "subscribed",
  unsubscribed: "unsubscribed",
  unactivated: "unactivated",
  activated: "activated",
  reserved: "reserved",
  completed: "completed",
  unassigned: "unassigned",

  merge_fields: [
    {
      name: "Development",
      tag: "DEVT",
      type: "text",
      public: true
    },
    {
      name: "Completion date",
      tag: "CDATE",
      type: "date",
      public: true,
      options: {
        date_format: "DD/MM/YYYY"
      }
    },
    {
      name: "Hoozzi status",
      tag: "HOOZSTATUS",
      type: "text",
      public: true
    },
    {
        name: "Postal name",
        tag: "POSTAL",
        type: "text",
        public: true
    },
    {
        name: "Building",
        tag: "BLDG",
        type: "text",
        public: true
    },
    {
        name: "Road",
        tag: "ROAD",
        type: "text",
        public: true
    },
    {
        name: "City",
        tag: "CITY",
        type: "text",
        public: true
    },
    {
        name: "County",
        tag: "COUNTY",
        type: "text",
        public: true
    },
    {
        name: "Postal code",
        tag: "ZIP",
        type: "text",
        public: true
    },
    {
        name: "Phase",
        tag: "PHASE",
        type: "text",
        public: true
    },
    {
        name: "Plot",
        tag: "PLOT",
        type: "text",
        public: true
    },
    {
        name: "Title",
        tag: "TITLE",
        type: "text",
        public: true
    },
    {
        name: "Unit type",
        tag: "UNIT_TYPE",
        type: "text",
        public: true
    },
    {
        name: "Hoozzi email updates",
        tag: "HOOZ_UPD",
        type: "text",
        public: true
    },
    {
        name: "Telephone updates",
        tag: "PHONE_UPD",
        type: "text",
        public: true
    },
    {
        name: "Post updates",
        tag: "POST_UPD",
        type: "text",
        public: true
    }
  ]
}
