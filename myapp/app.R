# app.R — Materialize + Icons / レスポンシブ最適化版（スマホ対応・サイドナビ）+ あなたの画像を使用
library(shiny)

ui <- fluidPage(
  tags$head(
    # スマホ倍率のズレ防止
    tags$meta(name="viewport", content="width=device-width, initial-scale=1.0"),
    
    # Materialize & Icons
    tags$link(rel="stylesheet",
              href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"),
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"),
    tags$link(href="https://fonts.googleapis.com/icon?family=Material+Icons", rel="stylesheet"),
    
    # ===== Responsive CSS =====
    tags$style(HTML("
      body { letter-spacing:.2px; }
      /* タイトルが重ならないように段階的に調整 */
      .brand-logo { font-weight:700; white-space:nowrap; font-size:28px; }
      @media (max-width:1200px){ .brand-logo { font-size:24px; } }
      @media (max-width:992px) { .brand-logo { font-size:22px; } }
      @media (max-width:600px) { .brand-logo { font-size:20px; } }

      .hero {
        border-radius:18px; padding:24px;
        background:
          radial-gradient(800px 400px at 10% 0%, rgba(0,151,167,.18), rgba(0,151,167,0) 55%),
          radial-gradient(700px 350px at 90% 10%, rgba(0,172,193,.16), rgba(0,172,193,0) 50%),
          linear-gradient(180deg, rgba(0,0,0,.02), rgba(0,0,0,0));
        box-shadow:0 16px 48px rgba(0,0,0,.08);
        margin-top:18px;
      }
      .hero h4 { font-weight:700; line-height:1.25; font-size:clamp(20px, 3.2vw, 32px); }

      .avatar { width:96px; height:96px; border-radius:50%; object-fit:cover;
                box-shadow:0 8px 26px rgba(0,0,0,.22); }

      .chips .chip { background:#E0F7FA; color:#007B83; font-weight:600; white-space:nowrap; margin:4px 6px 4px 0; }
      .superlink { display:flex; align-items:center; gap:12px; padding:14px 16px; border-radius:14px;
                   background:#fff; border:1px solid rgba(0,0,0,.06); box-shadow:0 8px 24px rgba(0,0,0,.06);
                   transition: transform .2s ease, box-shadow .2s ease; }
      .superlink:hover { transform:translateY(-2px); box-shadow:0 14px 30px rgba(0,0,0,.12); }
      .muted { color:#607d8b; }
      .card { border-radius:16px; }
      .site-footer { color:#78909c; font-size:13px; margin:28px 0 18px; }

      /* タブ：横スクロールで崩れ防止 */
      .tabs { overflow-x:auto; white-space:nowrap; -webkit-overflow-scrolling:touch; }
      .tabs .tab { display:inline-block; }
      .tabs .tab a { font-size:13px; padding:0 12px; }

      /* フェード（“ページ遷移”っぽく） */
      .fade-pane { opacity:0; transform:translateY(8px); transition:opacity .35s ease, transform .35s ease; }
      .fade-pane.show { opacity:1; transform:translateY(0); }

      @media (max-width:360px){
        .tabs .tab a { font-size:12px; padding:0 10px; }
        .avatar{width:84px;height:84px;}
        .hero { padding:18px; }
      }

      /* サイドナビ（中小画面） */
      .sidenav { width:260px; }
    ")),
    
    # ===== JS: Tabs/Sidenav初期化 & ヘッダー/サイドからタブ遷移 =====
    tags$script(HTML("
      document.addEventListener('DOMContentLoaded', function(){
        var tabsEl = document.querySelector('.tabs');
        var tabsInstance = tabsEl ? M.Tabs.init(tabsEl, {}) : null;

        // FAB
        var fabs = document.querySelectorAll('.fixed-action-btn');
        M.FloatingActionButton.init(fabs, {hoverEnabled:false});

        // Sidenav（右から出す）
        var sidenavs = document.querySelectorAll('.sidenav');
        M.Sidenav.init(sidenavs, {edge:'right'});

        // 初回フェード
        setTimeout(function(){
          document.querySelectorAll('.fade-pane').forEach(function(el){ el.classList.add('show'); });
        }, 60);

        // タブ切替後のフェード
        if (tabsEl) {
          tabsEl.querySelectorAll('a').forEach(function(a){
            a.addEventListener('click', function(){
              setTimeout(function(){
                document.querySelectorAll('.fade-pane').forEach(function(el){ el.classList.add('show'); });
              }, 80);
            });
          });
        }

        // 右上ヘッダーからタブ選択
        document.querySelectorAll('nav a[href^=\"#\"]').forEach(function(a){
          a.addEventListener('click', function(ev){
            var id = (this.getAttribute('href')||'').replace('#','');
            if(!id || !tabsInstance) return;
            ev.preventDefault();
            tabsInstance.select(id);
            var y = tabsEl.getBoundingClientRect().top + window.scrollY - 8;
            window.scrollTo({ top: y, behavior:'smooth' });
          });
        });

        // サイドナビからタブ選択（閉じてからスクロール）
        document.querySelectorAll('#mobile-menu a[href^=\"#\"]').forEach(function(a){
          a.addEventListener('click', function(ev){
            var id = (this.getAttribute('href')||'').replace('#','');
            if(!id || !tabsInstance) return;
            ev.preventDefault();
            tabsInstance.select(id);
            var sn = M.Sidenav.getInstance(document.getElementById('mobile-menu'));
            if(sn) sn.close();
            var y = tabsEl.getBoundingClientRect().top + window.scrollY - 8;
            window.scrollTo({ top: y, behavior:'smooth' });
          });
        });
      });
    "))
  ),
  
  # ===== ヘッダー（大画面は右上メニュー／中小はハンバーガーに切替） =====
  tags$nav(class="nav-wrapper teal",
           div(class="container",
               tags$a(href="#home", class="brand-logo", "ジョーソンランド"),
               # 大画面メニュー
               tags$ul(class="right hide-on-med-and-down",
                       tags$li(tags$a(href="#home",    tags$i(class="material-icons left", "home"),   "Home")),
                       tags$li(tags$a(href="#works",   tags$i(class="material-icons left", "work"),   "Works")),
                       tags$li(tags$a(href="#about",   tags$i(class="material-icons left", "person"), "About")),
                       tags$li(tags$a(href="#contact", tags$i(class="material-icons left", "send"),   "Contact"))
               ),
               # 中小画面：ハンバーガー
               tags$a(href="#", class="sidenav-trigger right hide-on-large-only",
                      `data-target`="mobile-menu",
                      tags$i(class="material-icons", "menu"))
           )
  ),
  
  # ===== サイドナビ（モバイル） =====
  tags$ul(id="mobile-menu", class="sidenav right-aligned",
          tags$li(tags$a(href="#home",    tags$i(class="material-icons left", "home"),   "Home")),
          tags$li(tags$a(href="#works",   tags$i(class="material-icons left", "work"),   "Works")),
          tags$li(tags$a(href="#about",   tags$i(class="material-icons left", "person"), "About")),
          tags$li(tags$a(href="#contact", tags$i(class="material-icons left", "send"),   "Contact"))
  ),
  
  # ===== タブ（横スクロール対応） =====
  div(class="container",
      tags$ul(class="tabs",
              tags$li(class="tab col s3", tags$a(href="#home",    "Home")),
              tags$li(class="tab col s3", tags$a(href="#works",   "Works")),
              tags$li(class="tab col s3", tags$a(href="#about",   "About")),
              tags$li(class="tab col s3", tags$a(href="#contact", "Contact"))
      )
  ),
  
  # ===== Home =====
  div(id="home", class="container",
      div(class="fade-pane",
          div(class="hero",
              div(class="row valign-wrapper",
                  div(class="col s12 m2 center",
                      # ★ あなたの画像（raw URL で直接表示）
                      tags$img(
                        src = "https://raw.githubusercontent.com/castella3/castella3.github.io/main/images/IMG_5739.jpg",
                        class = "avatar", alt = "プロフィール画像"
                      )
                      # もしくは www/images/avatar.jpg に置いた場合：
                      # tags$img(src = "images/avatar.jpg", class = "avatar", alt = "プロフィール画像")
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
                  tags$a(class="superlink", href="https://github.com/castella3", target="_blank",
                         tags$i(class="material-icons", "code"),
                         div(tags$div("GitHub", style="font-weight:700;"),
                             tags$div("コード・リポジトリ", class="muted")))),
              div(class="col s12 m6 l3",
                  tags$a(class="superlink", href="https://x.com/dkamimura0", target="_blank",
                         tags$i(class="material-icons", "chat"),
                         div(tags$div("X (Twitter)", style="font-weight:700;"),
                             tags$div("研究メモ・日々の投稿", class="muted")))),
              div(class="col s12 m6 l3",
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
  
  # ===== Works =====
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
  
  # ===== About =====
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
  
  # ===== Contact（重複ラベルなし） =====
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
            label = tagList(tags$i(class="material-icons left", "send"), " 送信（ダミー）"),
            class  = "btn waves-effect waves-light teal"
          ),
          tags$pre(id="preview", class="site-footer", " ")
      )
  ),
  
  # ===== FAB =====
  div(class="fixed-action-btn",
      tags$a(class="btn-floating btn-large teal", href="#home",
             tags$i(class="large material-icons", "arrow_upward"))
  )
)

server <- function(input, output, session) {
  observeEvent(input$send, {
    session$sendCustomMessage("setPreviewJS", list(
      text = paste0("【送信プレビュー】\n",
                    "お名前: ", input$name, "\n",
                    "メール: ", input$email, "\n\n",
                    input$msg)
    ))
  })
}

# pre へ書き込むJS
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
