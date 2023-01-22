# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
    email: 'a@a',
    password: 'aaaaaa',
)

Customer.create([
  { name: 'user_a', email: 'a@a', password: 'aaaaaa' },
  { name: 'user_b', email: 'b@b', password: 'aaaaaa' },
  { name: 'user_c', email: 'c@c', password: 'aaaaaa' }
])

Genre.create([
  { genre_name: 'ゲーム' },
  { genre_name: '漫画' },
  { genre_name: 'アプリ' }
])

Post.create([
  { customer_id: '1', genre_id: '1', title: 'a1', introduction: 'aa', status: 'published' },
  { customer_id: '1', genre_id: '2', title: 'a2', introduction: 'aa', status: 'published' },
  { customer_id: '1', genre_id: '3', title: 'a3', introduction: 'aa', status: 'published' },
  { customer_id: '2', genre_id: '1', title: 'b1', introduction: 'bb', status: 'published' },
  { customer_id: '2', genre_id: '2', title: 'b2', introduction: 'bb', status: 'published' },
  { customer_id: '2', genre_id: '3', title: 'b3', introduction: 'bb', status: 'published' },
  { customer_id: '3', genre_id: '1', title: 'c1', introduction: 'cc', status: 'published' }
])

Tag.create([
  { name: 'タグ1' },
  { name: 'タグ2' },
  { name: 'タグ3' },
  { name: 'タグ4' },
  { name: 'タグ5' }
])
