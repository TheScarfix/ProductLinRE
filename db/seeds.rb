# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SecurityQuestion.create(locale:   "de",
                        question: "Was ist das Gegenteil von leicht?",
                        answer:   "schwer")
SecurityQuestion.create(locale:   "de",
                        question: "Welcher Buchstabe folgt auf 'm' ?",
                        answer:   "n")
SecurityQuestion.create(locale:   "de",
                        question: "Wann brach der erste Weltkrieg aus?",
                        answer:   "1914")
SecurityQuestion.create(locale:   "de",
                        question: "Wie viele Tage haben zwei Jahre?",
                        answer:   "730")
SecurityQuestion.create(locale:   "en",
                        question: "What's the opposite of 'light'?",
                        answer:   "heavy")
SecurityQuestion.create(locale:   "en",
                        question: "Which letter follows 'm' ?",
                        answer:   "n")
SecurityQuestion.create(locale:   "en",
                        question: "When did the First World War start?",
                        answer:   "1914")
SecurityQuestion.create(locale:   "en",
                        question: "Please enter the day before Thursday",
                        answer:   "wednesday")


if Rails.env == "development" || Rails.env == "test"
  users = []

  user1 = User.new(name:        "test1",
                   email:       "test1@test.de",
                   password:    "test123",
                   description: "Description 1")
  user1.skip_confirmation!
  user1.save(validate: false)
  user2 = User.new(name:        "test2",
                   email:       "test2@test.de",
                   password:    "test123",
                   description: "Description 2")
  user2.skip_confirmation!
  user2.save(validate: false)
  user3 = User.new(name:        "admin1",
                   email:       "Admin1@test.de",
                   password:    "test123",
                   description: "Description 3",
                   is_admin:    "1")
  user3.skip_confirmation!
  user3.save(validate: false)
  users << user1 << user2 << user3

  projects = []

  9.times do |i|
    projects << Project.create(name:        "Project ##{i + 1}",
                               description: "Project ##{i + 1} Description",
                               user:        users.sample)
  end

  features = []

  27.times do |i|
    features << Feature.create(name:        "Feature ##{i + 1}",
                               description: "Feature ##{i + 1} Description",
                               project:     projects.sample)
  end

  products = []

  27.times do |i|
    products << Product.create(name:        "Product ##{i + 1}",
                               description: "Product ##{i + 1} Description",
                               project:     projects.sample)
  end

  Product.all.each do |product|
    product.update features: product.project.features.sample(3)
  end

  artifacts = []
  27.times do |i|
    artifacts << Artifact.create(name:        "Artifact ##{i + 1}",
                                 description: "Artifact ##{i + 1} Description",
                                 file:        {
                                     io:           File.open(Rails.root.join("public/artifacts/sample (#{i + 1}).png")),
                                     filename:     "sample (#{i + 1}).png",
                                     content_type: "image/png"
                                 },
                                 user:        users.sample)
  end

  Artifact.all.each do |artifact|
    artifact.update features: features.sample(3)
  end

end
