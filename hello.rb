# sinatra有帶一個套件叫erb

require 'sinatra'
require 'sinatra/reloader' if development? 

enable :sessions # 讓號碼牌功能可以用 ＃reloader沒辦法處理這個 所以修改相關程式碼後 要重新啟動伺服器
# https://webapps-for-beginners.rubymonstas.org/sessions/sinatra_sessions.html

get '/' do 
    @name = session[:numbercard_tamy]  # 實體變數 ＃供views中檔案存取 #將號碼牌的內容 指定給 @name實體變數
    erb :index, layout: :my_layout
    #當網址於根目錄
    # erb :index 會去讀取views/index.erb檔案 # 交給前端 ＃:index為符號
    # 套用my_layout版型（公版）
    # 讀取index檔案 把index檔案的內容 塞到 my_layout版型（公版 裡面要挖洞（yield）用以塞index內容）中
end 

get '/say_hello/:name' do
    @name = params[:name] # params[:name]會產生一個Hash，並去找出:name key所對應的value
    # :name是符號，舊式hash寫法下的key
    # 網址中打在:name的值 會被 指定給 實體變數name
    # 內容修改都在此ruby主程式進行，html（.erb）專心負責畫面呈現即可
    erb :index, layout: :my_layout
end

# 一般瀏覽需求（GET）
get '/form' do # 當網址為.../form
    erb :form
    # erb :form 會去讀取views/form.erb檔案
end

# 寫處理POST需求的方法（同一網址路徑 不同方法 讀取不同erb檔案）
post '/form' do # 當網址為.../form 且為使用POST方法
    h = params[:height] .to_f / 100
    # params[:height]會產生一個Hash，並去找出:height（name屬性為height 的input標籤 中 所輸入的值） key所對應的value
    # 透過網路傳輸過來的東西 都是字串，所以要轉成數字
    # Ruby的數字運算 整數/整數只會得到整數 故 浮點的數字 而非轉成整數
    w = params[:weight] .to_f
    bmi = w / (h * h) #　在ruby檔做運算，把運算結果存放到 變數，讓html去呈現 變數
    erb :result, locals: {result: bmi} 
    # 就讀取views/result.erb檔案（沒有說網址設/form就會讀form.erb檔，什麼路徑對應讀哪一個erb檔都可以）
    # 帶一個 區域變數result（裝的值 是這裡 bmi存放的運算後值） 給views/result.erb檔案
    # 區域變數生命週期較實體變數短 比較不會污染其他地方
end

# 會員系統
get '/login' do
    erb :login
end

post '/login' do
    username = params[:username] 
    # params[:username]會產生一個Hash，並去找出:username（name屬性為username 的input標籤 中 所輸入的值） key所對應的value
    password = params[:password]

    if username == 'tamy8677@gmail.com' and password == '1234'
        session[:numbercard_tamy] = username # 指定username（使用者名稱）的內容 給 :numbercard_tamy 號碼牌 
        # session像一個hash 可以塞很多號碼牌
    end

    redirect '/' # 轉址回首頁
  end