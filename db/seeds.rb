group_name = %w(blue
               red
               pink
               orange
               purple
               green
               yellow
               grey
               amber
               white
               black
               navy
               olive
               cyan
               scarlet
               vermilion
               brown
               magenta
               gold
               silver)
alpha = %w(A B C D E F G H I J)
page_title = %w(
  ドローン自作
  タチコマ制作
  自作セグウェイ
  ファミコン自作
  ２足歩行ロボット
  フェイスブックいいね連動装置
  R2-D2制作
  ビッグドッグ制作
  遠隔ロックシステム
  レゴブロックアクチュエーター
  真空管アンプ制作
  バトル相撲ロボット優勝機
  自動４輪走行制御
  電子楽器制作
  アーケード版パックマン制作
  ３Dプリンター自作
  電動キックボード自作
  大学ロボコン優勝機
  オキュラスリフト自作
  ロボットアーム制御
  Lチカ回路
  定電圧回路
  オペアンプ回路
  ラズベリーパイ初心者
  Arduino導入
  トランジスタラジオ
  シリアル通信制御
  音センサー制御
  サーボモーター姿勢制御
  ミニ４駆改造)
content = "サンプルテキストです" * 15
content_short = "サンプルテキストです" * 12
kinds = %w(description
           breadboard
           description
           circuit
           description
           element_list
           breadboard
           program
           cad
           other
           )
#####################################
#プロセス１
#####################################
User.create!(name:  "bot",
            email: "bot@test.com",
            password:              "password",
            password_confirmation: "password",
            image: File.new(File.join(Rails.root, "db/fixtures/users/", "1.jpg")),
            admin: true)

99.times do |n|
  name = Faker::Name.name
  email = "user#{n+2}@test.com"
  password = "password"
  image_path = File.join(Rails.root, "db/fixtures/users/", "#{n+2}.jpg")
  image = File.new(image_path)
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              image: image)
end

30.times do |n| #30回繰り返し#10
  
  if n < 10 #1〜10回目
    Group.create!(name: group_name[n]) #グループ1〜10作成
    
    10.times do |m| #同グループ内でユーザー10人分 ページ作成 連番
      if m == 0 #bot
        Page.create!(user_id: 1, group_id: n+1, title: "#{page_title[n]}(デフォルトページ)", content: content)
      else #bot以外の ユーザー 11 21 31 41 51 61 71 81 91 は除外
        Page.create!(user_id: n*10 + m+1, group_id: n+1, title: "#{page_title[n]}#{alpha[m]}", content: content)
      end
    end
    
  elsif n >=10 && n < 20 #11〜20回目
    Group.create!(name: group_name[n])
    
    10.times do |m| #同グループ内でユーザー10人分 ページ作成 ボックス
      if m == 0 #bot
        Page.create!(user_id: 1, group_id: n+1, title: "#{page_title[n]}(デフォルトページ)", content: content)
      else #bot以外の ユーザー 91 92 93 94 95 96 97 98 99 は除外
        Page.create!(user_id: m*10 + (n%10)+1, group_id: n+1, title: "#{page_title[n]}#{alpha[m]}", content: content)
      end
    end
  else #21〜30回目
    10.times do |m| #グループなしでユーザー10人分 ページ作成
      Page.create!(user_id: (n%10)*10 + m+1, title: "#{page_title[n]}#{alpha[m]}", content: content)
    end
  end
end
#####################################
#プロセス2
#####################################
10.times do |n|
  10.times do |m|#10ページ分作成
    10.times do |c| #10カード作成
      if c == 0
        image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{2*n+1}.jpg")
      elsif c == 2
        image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{2*n+2}.jpg")
      elsif c == 1 || c == 3 || c == 5 || c == 6
        image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{Random.rand(1 .. 40)}.jpg")
      elsif c == 4
        image_path = File.join(Rails.root, "db/fixtures/glaph/", "#{Random.rand(1 .. 40)}.jpg")
      else
        image_path = File.join(Rails.root, "db/fixtures/program/", "#{Random.rand(1 .. 40)}.js")
      end
      if m == 0 #bot 
        Card.create!(image: File.new(image_path), user_id: 1, page_id: 10*n+1, kind: kinds[c], title: kinds[c], content: content_short)
      else #bot以外のメンバー
        Card.create!(image: File.new(image_path), user_id: 10*n+m+1, page_id: 10*n+m+1, kind: kinds[c], title: "#{kinds[c]}-#{10*n+m+1}", content: content_short)
      end
    end
  end
end
#####################################
#プロセス3
#####################################
# 10.times do |n|
#   10.times do |m|#10ページ分作成
#     10.times do |c| #10カード作成
#       if c == 0
#         image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{n*2+21}.jpg")
#       elsif c == 2
#         image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{n*2+22}.jpg")
#       elsif c == 1 || c == 3 || c == 5 || c == 6
#         image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{Random.rand(1 .. 40)}.jpg")
#       elsif c == 4
#         image_path = File.join(Rails.root, "db/fixtures/glaph/", "#{Random.rand(1 .. 40)}.jpg")
#       else
#         image_path = File.join(Rails.root, "db/fixtures/program/", "#{Random.rand(1 .. 40)}.js")
#       end
#       if m == 0 #bot 
#         Card.create!(image: File.new(image_path), user_id: 1, page_id: 10*n+101, kind: kinds[c], title: kinds[c], content: content_short)
#       else #bot以外のメンバー
#         Card.create!(image: File.new(image_path), user_id: n+1+m*10, page_id: 10*n+m+101, kind: kinds[c], title: "#{kinds[c]}-#{n+1+m*10}", content: content_short)
#       end
#     end
#   end
# end
#####################################
#プロセス4
#####################################
# 10.times do |n| #残り分
#   10.times do |m|#10ページ分作成
#     i = 40 #description jpg +2
#     p = 200 #ページID補正 +10
#     10.times do |c| #10カード作成
#       if c == 0
#         image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{i+(2*n)+1}.jpg")
#       elsif c == 2
#         image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{i+(2*n)+2}.jpg")
#       elsif c == 1 || c == 3 || c == 5 || c == 6
#         image_path = File.join(Rails.root, "db/fixtures/#{kinds[c]}/", "#{Random.rand(1 .. 40)}.jpg")
#       elsif c == 4
#         image_path = File.join(Rails.root, "db/fixtures/glaph/", "#{Random.rand(1 .. 40)}.jpg")
#       else
#         image_path = File.join(Rails.root, "db/fixtures/program/", "#{Random.rand(1 .. 40)}.js")
#       end
#       Card.create!(image: File.new(image_path), user_id: n*10 + m+1, page_id: p+n*10+m+1, kind: kinds[c], title: "#{kinds[c]}-#{n*10 + m+1}", content: content_short)
#     end
#   end
# end
# #####################################
# #プロセス5
# #####################################
# 100.times do |n|
#   50.times do |r|
#     if r<10
#       image_path = File.join(Rails.root, "db/fixtures/breadboard/", "#{Random.rand(1 .. 40)}.jpg")
#       Card.create!(image: File.new(image_path), user_id: n+1, kind: "breadboard", title: "breadboard-#{n+1}", content: content_short)
#     elsif r>=10 && r<20
#       image_path = File.join(Rails.root, "db/fixtures/circuit/", "#{Random.rand(1 .. 40)}.jpg")
#       Card.create!(image: File.new(image_path), user_id: n+1, kind: "circuit", title: "circuit-#{n+1}", content: content_short)
#     elsif r>=20 && r<30
#       image_path = File.join(Rails.root, "db/fixtures/element_list/", "#{Random.rand(1 .. 40)}.jpg")
#       Card.create!(image: File.new(image_path), user_id: n+1, kind: "element_list", title: "element_list-#{n+1}", content: content_short)
#     else
#       image_path = File.join(Rails.root, "db/fixtures/dummy/", "#{Random.rand(1 .. 40)}.jpg")
#       Card.create!(image: File.new(image_path), user_id: n+1, kind: "description", title: "description-#{n+1}", content: content_short)
#     end
#   end
# end
# #####################################
# #プロセス6
# #####################################
# 300.times do |n| #300#100
#   page = Page.find(n+1)
#   card_order = [10*n+1, 10*n+2, 10*n+3, 10*n+4, 10*n+5, 10*n+6, 10*n+7, 10*n+8, 10*n+9, 10*n+10]
#   page.card_order = card_order
#   page.save
# end