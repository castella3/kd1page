# app.R — Materialize + Material Icons / 右上ヘッダーでタブ遷移＆SNS実リンク版（プロット無し）
library(shiny)

ui <- fluidPage(
  tags$head(
    # Materialize
    tags$link(rel="stylesheet", href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"),
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"),
    # Google Material Icons
    tags$link(href="https://fonts.googleapis.com/icon?family=Material+Icons", rel="stylesheet"),
    # Custom CSS
    tags$style(HTML("
      body { letter-spacing:.2px; }
      .brand-logo { font-weight: 700; }
      .hero {
        border-radius: 18px; padding: 28px;
        background:
          radial-gradient(800px 400px at 10% 0%, rgba(0,151,167,.18), rgba(0,151,167,0) 55%),
          radial-gradient(700px 350px at 90% 10%, rgba(0,172,193,.16), rgba(0,172,193,0) 50%),
          linear-gradient(180deg, rgba(0,0,0,.02), rgba(0,0,0,0));
        box-shadow: 0 16px 48px rgba(0,0,0,.08);
        margin-top: 18px;
      }
      .avatar {
        width: 110px; height: 110px; border-radius: 50%; object-fit: cover;
        box-shadow: 0 8px 26px rgba(0,0,0,.22);
      }
      .chips .chip { background:#E0F7FA; color:#007B83; font-weight:600; }
      .superlink {
        display:flex; align-items:center; gap:12px; padding:14px 16px; border-radius:14px;
        background:#fff; border:1px solid rgba(0,0,0,.06); box-shadow: 0 8px 24px rgba(0,0,0,.06);
        transition: transform .2s ease, box-shadow .2s ease;
      }
      .superlink:hover { transform: translateY(-2px); box-shadow: 0 14px 30px rgba(0,0,0,.12); }
      .muted { color:#607d8b; }
      .fade-pane { opacity:0; transform: translateY(8px); transition: opacity .35s ease, transform .35s ease; }
      .fade-pane.show { opacity:1; transform: translateY(0); }
      .card { border-radius: 16px; }
      .site-footer { color:#78909c; font-size:13px; margin: 28px 0 18px; }
      .nav-wrapper.teal { padding: 0 12px; }
    ")),
    # init scripts（右上ヘッダー→タブ切り替えも対応）
    tags$script(HTML("
      document.addEventListener('DOMContentLoaded', function() {
        var tabsEl = document.querySelector('.tabs');
        var tabsInstance = M.Tabs.init(tabsEl, {}) || M.Tabs.getInstance(tabsEl);
        var fabs = document.querySelectorAll('.fixed-action-btn');
        M.FloatingActionButton.init(fabs, {hoverEnabled: false});

        setTimeout(function(){
          document.querySelectorAll('.fade-pane').forEach(function(el){ el.classList.add('show'); });
        }, 60);

        document.querySelectorAll('.tabs a').forEach(function(a){
          a.addEventListener('click', function(){
            setTimeout(function(){
              document.querySelectorAll('.fade-pane').forEach(function(el){
                if(el.closest('.col.s12') ? el.closest('.col.s12').style.display !== 'none' : true){
                  el.classList.add('show');
                }
              });
            }, 80);
          });
        });

        // 右上ヘッダーからもタブ切り替え
        document.querySelectorAll('nav a[href^=\"#\"]').forEach(function(a){
          a.addEventListener('click', function(ev){
            var id = (this.getAttribute('href') || '').replace('#','');
            if (tabsInstance && id) {
              ev.preventDefault();
              tabsInstance.select(id);
              // タブ位置へスムーススクロール（ナビの下あたり）
              var y = tabsEl.getBoundingClientRect().top + window.scrollY - 8;
              window.scrollTo({ top: y, behavior: 'smooth' });
            }
          });
        });
      });
    "))
  ),
  
  # ======= ナビバー =======
  tags$nav(class="nav-wrapper teal",
           div(class="container",
               tags$a(href="#home", class="brand-logo", "ジョーソンランド"),
               tags$ul(class="right hide-on-med-and-down",
                       tags$li(tags$a(href="#home",    tags$i(class="material-icons left", "home"),   "Home")),
                       tags$li(tags$a(href="#works",   tags$i(class="material-icons left", "work"),   "Works")),
                       tags$li(tags$a(href="#about",   tags$i(class="material-icons left", "person"), "About")),
                       tags$li(tags$a(href="#contact", tags$i(class="material-icons left", "send"),   "Contact"))
               )
           )
  ),
  
  # ======= タブ =======
  div(class="container",
      tags$ul(class="tabs tabs-fixed-width",
              tags$li(class="tab col s3", tags$a(href="#home",    "Home")),
              tags$li(class="tab col s3", tags$a(href="#works",   "Works")),
              tags$li(class="tab col s3", tags$a(href="#about",   "About")),
              tags$li(class="tab col s3", tags$a(href="#contact", "Contact"))
      )
  ),
  
  # ======= Home =======
  div(id="home", class="container",
      div(class="fade-pane",
          div(class="hero",
              div(class="row valign-wrapper",
                  div(class="col s12 m2 center",
                      tags$img(src="https://avatars.githubusercontent.com/u/14101776?s=200&v=4", class="avatar", alt="avatar")
                  ),
                  div(class="col s12 m10",
                      tags$h4("Hi, I'm ジョーソンランド"),
                      p("心理統計の大学院生です。自由記述の飽和推定、LNRE（fZM）・再捕獲法の比較、R/Shiny・Stan を使った可視化に取り組んでいます。"),
                      div(class="chips",
                          span(class="chip","R/Shiny"),
                          span(class="chip","LNRE / Zipf"),
                          span(class="chip","Capture–Recapture"),
                          span(class="chip","Psychometrics")
                      ),
                      tags$br(),
                      div(class="row",
                          div(class="col s12 m4",
                              tags$a(href="#about", class="btn waves-effect waves-light teal",
                                     tags$i(class="material-icons left", "person"), "自己紹介")),
                          div(class="col s12 m4",
                              tags$a(href="#works", class="btn waves-effect waves-light white teal-text text-darken-2",
                                     style="border:1px solid rgba(0,0,0,.12);",
                                     tags$i(class="material-icons left", "work"), "作品・研究")),
                          div(class="col s12 m4",
                              tags$a(href="#contact", class="btn waves-effect waves-light white teal-text text-darken-2",
                                     style="border:1px solid rgba(0,0,0,.12);",
                                     tags$i(class="material-icons left", "send"), "連絡"))
                      )
                  )
              )
          ),
          tags$h5(tags$i(class="material-icons tiny", "link"), " SNS / Links"),
          div(class="row",
              div(class="col s12 m6 l3",
                  # GitHub 実リンク
                  tags$a(class="superlink", href="https://github.com/castella3", target="_blank",
                         tags$i(class="material-icons", "code"),
                         div(tags$div("GitHub", style="font-weight:700;"),
                             tags$div("コード・リポジトリ", class="muted")))),
              div(class="col s12 m6 l3",
                  # X (Twitter) 実リンク
                  tags$a(class="superlink", href="https://x.com/dkamimura0", target="_blank",
                         tags$i(class="material-icons", "chat"),
                         div(tags$div("X (Twitter)", style="font-weight:700;"),
                             tags$div("研究メモ・日々の投稿", class="muted")))),
              div(class="col s12 m6 l3",
                  # LinkedIn は未指定のまま（必要ならURLください）
                  tags$a(class="superlink", href="https://www.linkedin.com/in/yourname", target="_blank",
                         tags$i(class="material-icons", "badge"),
                         div(tags$div("LinkedIn", style="font-weight:700;"),
                             tags$div("職務経歴・スキル", class="muted")))),
              div(class="col s12 m6 l3",
                  tags$a(class="superlink", href="mailto:you@example.com",
                         tags$i(class="material-icons", "mail"),
                         div(tags$div("Email", style="font-weight:700;"),
                             tags$div("you@example.com", class="muted"))))
          ),
          tags$br(), tags$br()
      )
  ),
  
  # ======= Works（プロット無しの紹介カードのみ） =======
  div(id="works", class="container",
      div(class="fade-pane",
          tags$h4(tags$i(class="material-icons", "work"), " 作品・研究"),
          div(class="row",
              div(class="col s12 m6",
                  div(class="card hoverable",
                      div(class="card-image",
                          tags$img(src="https://picsum.photos/800/400?random=12"),
                          span(class="card-title", "LNRE 可視化ダッシュボード")
                      ),
                      div(class="card-content",
                          p("zipfR を用いた語彙成長曲線、有限母集団を想定した飽和到達点推定など。")
                      ),
                      div(class="card-action",
                          tags$a(href="#contact", class="teal-text text-darken-2", "お問い合わせへ")
                      )
                  )
              ),
              div(class="col s12 m6",
                  div(class="card hoverable",
                      div(class="card-image",
                          tags$img(src="https://picsum.photos/800/400?random=22"),
                          span(class="card-title", "再捕獲法の指標比較")
                      ),
                      div(class="card-content",
                          p("Chapman推定・Schnabelなど複数指標の比較用小ツール。")
                      ),
                      div(class="card-action",
                          tags$a(href="https://your-portfolio.example", target="_blank", "Portfolio"),
                          tags$span("　"),
                          tags$a(href="https://github.com/castella3", target="_blank", "GitHub")
                      )
                  )
              )
          )
      )
  ),
  
  # ======= About =======
  div(id="about", class="container",
      div(class="fade-pane",
          tags$h4(tags$i(class="material-icons", "person"), " 自己紹介"),
          p("専修大学（心理統計）M2。自由記述調査の飽和を定量化する研究に従事。再捕獲法（Toyoda et al., 2013）と LNRE（fZM）を比較し、R/Shiny・Stanで可視化。"),
          tags$ul(
            tags$li("語彙成長曲線（VGC）・EV曲線の解析"),
            tags$li("有限母集団を前提とした飽和率推定"),
            tags$li("スロープしきい値（例：0.05）による到達判定"),
            tags$li("質的データの定量化・可視化")
          )
      )
  ),
  
  # ======= Contact（重複ラベルなし） =======
  div(id="contact", class="container",
      div(class="fade-pane",
          tags$h4(tags$i(class="material-icons", "send"), " お問い合わせ"),
          div(class="row",
              div(class="input-field col s12 m6",
                  textInput("name", label = "お名前", placeholder = "山田 太郎")
              ),
              div(class="input-field col s12 m6",
                  textInput("email", label = "メール", placeholder = "you@example.com")
              )
          ),
          div(class="input-field col s12",
              textAreaInput("msg", label = "メッセージ", value = "", rows = 5, placeholder = "ご用件をどうぞ")
          ),
          actionButton(
            "send",
            label = tagList(tags$i(class = "material-icons left", "send"), " 送信（ダミー）"),
            class = "btn waves-effect waves-light teal"
          ),
          tags$pre(id="preview", class="site-footer", " ")
      )
  ),
  
  # ======= FAB =======
  div(class="fixed-action-btn",
      tags$a(class="btn-floating btn-large teal", href="#home",
             tags$i(class="large material-icons", "arrow_upward"))
  )
)

server <- function(input, output, session) {
  # Contact ダミー送信
  observeEvent(input$send, {
    txt <- paste0(
      "【送信プレビュー】\n",
      "お名前: ", input$name, "\n",
      "メール: ", input$email, "\n\n",
      input$msg
    )
    session$sendCustomMessage("setPreviewJS", list(text = txt))
  })
}

# pre 要素へ書き込むJS
ui <- tagList(
  ui,
  tags$script(HTML("
    Shiny.addCustomMessageHandler('setPreviewJS', function(x){
      var el = document.getElementById('preview');
      if(el){ el.textContent = x.text || ''; }
    });
  "))
)

shinyApp(ui, server)
