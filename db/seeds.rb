User.create(full_name: "Ebo Lee", username: "ebo.lee", email: "ebo.lee@marketplace.com", password: "password1", biography: "Ebo is a first-time homebuyer.", seller: false)
User.create(full_name: "Sega Lake", username: "sega.lake", email: "sega.lake@marketplace.com", password: "password2", biography: "Being in the real estate industry for more than 10 years, Sega is an experienced property investor", seller: true)
User.create(full_name: "Jeffrey Adams", username: "jeffrey.adams", email: "jeffrey.adams@marketplace.com", password: "password3", biography: "Jeffrey is a business consultant specialize in real estate investment consulting", seller: true)
User.create(full_name: "Leon Kennedy", username: "leon.kennedy", email: "leon.kennedy@marketplace.com", password: "password4", biography: "Leon is a secret agent, a friend of the president of the United States.", seller: false)

Property.create(address: "123 Main Street, Berkeley, CA 94712", picture: "🏭", overview: "Affordable property for sale. Perhaps the most affordable in the entire region!", price: 140000, seller_id: 1)
Property.create(address: "1998 Avocado Ave, Jackson, MS 49182", picture: "🏦", overview: "Property with great growth potential. It won't last very long!", price: 90000, seller_id: 2)
Property.create(address: "10245 Apple Court, Houston, TX 34212", picture: "🏚", overview: "New construction. Open house this Sunday from 9am to 6pm. Come and visit!", price: 128000, seller_id: 3)

UserProperty.create(message: "I am ready to make an offer", user_id: 1, property_id: 1)
UserProperty.create(message: "Does the propety has HOA?", user_id: 2, property_id: 2)
UserProperty.create(message: "The average of the housing price is lower.", user_id: 5, property_id: 2)
UserProperty.create(message: "I'd like to schedule a tour.", user_id: 5, property_id: 4)