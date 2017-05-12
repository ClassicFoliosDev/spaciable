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
      # Development column
      name: "Development",
      tag: "DEVT",
      type: "text",
      public: true
    },
    {
      # Completion date column
      name: "Completion date",
      tag: "CDATE",
      type: "date",
      public: true,
      options: {
        date_format: "DD/MM/YYYY"
      }
    },
    {
      # Hoozzi status column
      name: "Hoozzi status",
      tag: "HOOZSTATUS",
      type: "text",
      public: true
    }
  ]
}
