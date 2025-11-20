# app.R — Materialize + Icons / レスポンシブ版
# フッターを横スクロールさせず、幅に応じて折り返し表示
# 画像: www/img/raccoon.jpg, work_lnre.jpg, work_capture.jpg, app_preview.jpg
# 発表資料（例）: www/docs/tokyor_2024_saturation.pdf, www/docs/tokyor_2024_handson.html

library(shiny)

pro_url <- "https://your-pro-app.example"
utm_nav   <- paste0(pro_url, "?utm_source=portfolio&utm_medium=nav&utm_campaign=app_cta")
utm_body  <- paste0(pro_url, "?utm_source=portfolio&utm_medium=body&utm_campaign=app_cta")

ui <- fluidPage(
  tags$head(
    tags$meta(name="viewport", content="width=device-width, initial-scale=1.0"),
    # ★ ブラウザタブに表示されるタイトル
    tags$title("Kamimura Daichi | R/Shiny Portfolio"),
    tags$link(rel="stylesheet",
              href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"),
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js", defer=NA),
    tags$link(href="https://fonts.googleapis.com/icon?family=Material+Icons", rel="stylesheet"),
    tags$link(rel="icon",             href="img/raccoon.jpg?v=7", type="image/jpeg"),
    tags$link(rel="shortcut icon",    href="img/raccoon.jpg?v=7", type="image/jpeg"),
    tags$link(rel="apple-touch-icon", href="img/raccoon.jpg?v=7"),
    
    tags$style(HTML("
      body { letter-spacing:.2px; }
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

      .avatar { width:96px; height:96px; border-radius:50%; object-fit:cover; box-shadow:0 8px 26px rgba(0,0,0,.22); }
      .avatar-lg { width:112px; height:112px; border-radius:50%; object-fit:cover; box-shadow:0 10px 28px rgba(0,0,0,.22); }

      .chips .chip { background:#E0F7FA; color:#007B83; font-weight:600; white-space:nowrap; margin:4px 6px 4px 0; }
      .superlink { display:flex; align-items:center; gap:12px; padding:14px 16px; border-radius:14px;
                   background:#fff; border:1px solid rgba(0,0,0,.06); box-shadow:0 8px 24px rgba(0,0,0,.06);
                   transition: transform .2s ease, box-shadow .2s ease; }
      .superlink:hover { transform:translateY(-2px); box-shadow:0 14px 30px rgba(0,0,0,.12); }
      .muted { color:#607d8b; }
      /* GitHub説明行は字間0 & 途中改行しにくく */
      .superlink .muted { letter-spacing:0; }
      .card { border-radius:16px; }

      .tabs { overflow-x:auto; white-space:nowrap; -webkit-overflow-scrolling:touch; }
      .tabs .tab { display:inline-block; }
      .tabs .tab a { font-size:13px; padding:0 12px; }
      @media (min-width: 993px){
        .tabs { display:flex; white-space:normal; overflow:visible; width:100%; justify-content:space-between; }
        .tabs .tab { display:block; flex:1 1 0; text-align:center; }
        .tabs .tab a { display:block; padding:0 0; font-size:15px; }
      }

      .fade-pane { opacity:0; transform:translateY(8px); transition:opacity .35s ease, transform .35s ease; }
      .fade-pane.show { opacity:1; transform:translateY(0); }

      @media (max-width:360px){
        .tabs .tab a { font-size:12px; padding:0 10px; }
        .avatar{width:84px;height:84px;}
        .hero { padding:18px; }
      }

      .pill { display:inline-block; padding:4px 10px; border-radius:999px; background:#E0F7FA; color:#007B83; font-weight:700; font-size:12px; }
      .check { color:#26a69a; vertical-align:middle; }
      .work-title { margin:12px 0 6px; font-weight:800; color:#212121; line-height:1.25; font-size: clamp(18px, 2.2vw, 24px); letter-spacing: .2px; }
      .work-thumb { border-radius:14px; box-shadow:0 8px 20px rgba(0,0,0,.10); }

      #to-top { opacity:0; transform: translateY(8px) scale(.96); pointer-events:none; transition: opacity .25s ease, transform .25s ease; }
      #to-top.show { opacity:1; transform: translateY(0) scale(1); pointer-events:auto; }

      .btn-flex { display:flex; gap:12px; align-items:stretch; flex-wrap:wrap; }
      .btn-flex > a.btn { flex:1 1 0; min-width:0; display:flex; align-items:center; justify-content:center; gap:8px; height:auto;
                          line-height:1.35; padding:12px 18px; white-space:normal !important; word-break:keep-all; overflow-wrap:anywhere; }
      .btn-flex > a.btn i.left { margin-right:6px; }
      @media (max-width: 600px){ .btn-flex.home-cta { flex-direction:column; } .btn-flex.home-cta > a.btn { width:100%; } }
      .btn-flex.app-cta { display:grid; grid-template-columns: 1fr 1fr; gap:12px; }
      .btn-flex.app-cta > a.btn { width:100%; }
      @media (max-width: 992px){ .btn-flex.app-cta { grid-template-columns: 1fr; } }

      .about-hero {
        border-radius:18px; padding:24px;
        background:
          radial-gradient(900px 460px at 0% 0%, rgba(0,151,167,.18), rgba(0,151,167,0) 55%),
          radial-gradient(800px 420px at 100% 10%, rgba(0,172,193,.16), rgba(0,172,193,0) 50%),
          linear-gradient(180deg, rgba(0,0,0,.02), rgba(0,0,0,0));
        box-shadow:0 16px 48px rgba(0,0,0,.08); margin-top:6px;
      }
      .tag-cloud .chip { margin:4px 6px 0 0; font-weight:600; }
      .about-divider { height:1px; background:linear-gradient(90deg, rgba(0,0,0,.08), rgba(0,0,0,0)); margin:14px 0 6px; }

      .stat-grid { display:grid; grid-template-columns: repeat(4, 1fr); gap:14px; }
      @media (max-width: 992px){ .stat-grid { grid-template-columns: repeat(2, 1fr);} }
      @media (max-width: 480px){ .stat-grid { grid-template-columns: 1fr;} }
      .stat-card { border-radius:16px; background:#fff; border:1px solid rgba(0,0,0,.06);
                   box-shadow:0 10px 24px rgba(0,0,0,.06); padding:14px 16px; display:flex; align-items:flex-start; gap:12px; }
      .stat-card i { color:#26a69a; }
      .stat-title { font-weight:800; color:#263238; letter-spacing:.2px; }
      .stat-sub   { color:#607d8b; font-size:13px; margin-top:2px; }

      .timeline { position:relative; margin:8px 0 0 6px; padding-left:24px; }
      .timeline:before { content:''; position:absolute; left:8px; top:0; bottom:0; width:2px; background:rgba(0,0,0,.08); }
      .tl-item { position:relative; margin:14px 0; }
      .tl-item:before {
        content:''; position:absolute; left:-22px; top:4px; width:12px; height:12px; border-radius:50%;
        background:#26a69a; box-shadow:0 0 0 4px rgba(38,166,154,.15);
      }
      .tl-title { font-weight:700; color:#263238; }
      .tl-meta  { color:#78909c; font-size:12px; margin-bottom:4px; }

      .collapsible { border-radius:14px; overflow:hidden; }
      .collapsible-header { font-weight:700; }
      .collapsible-body { background:#fafafa; }

      /* ======= フッター（横スクロール廃止・折り返し対応） ======= */
      .site-footer { background:#009688; color:#e0f2f1; padding:10px 0; margin-top:28px; }
      .footer-row { display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap; }
      .footer-copy { font-weight:600; letter-spacing:.2px; }
      .footer-links { display:flex; align-items:center; gap:10px; flex-wrap:wrap; /* ← wrap */ }
      .footer-chip { display:inline-flex; align-items:center; gap:6px; padding:6px 10px; border-radius:999px;
                     background:rgba(255,255,255,.08); color:#e0f2f1; border:1px solid rgba(255,255,255,.16);
                     text-decoration:none; font-weight:600; font-size:13px; white-space:nowrap; }
      .footer-chip:hover { background:rgba(255,255,255,.14); }
      .footer-chip i { font-size:18px; line-height:1; }

      @media (max-width:600px){
        .footer-row { flex-direction:column; align-items:flex-start; gap:8px; } /* とても狭い時は縦並び */
      }

      /* 1語として扱い、途中改行させない */
      .nowrap-block { display:inline-block; white-space:nowrap; }
    "))
  ),
  
  tags$script(HTML("
    document.addEventListener('DOMContentLoaded', function(){
      var tabsEl = document.querySelector('.tabs');
      var tabsInstance = tabsEl ? M.Tabs.init(tabsEl, {}) : null;
      M.FloatingActionButton.init(document.querySelectorAll('.fixed-action-btn'), {hoverEnabled:false});
      M.Sidenav.init(document.querySelectorAll('.sidenav'), {edge:'right'});
      M.Collapsible.init(document.querySelectorAll('.collapsible'), {accordion:false});
      setTimeout(function(){ document.querySelectorAll('.fade-pane').forEach(function(el){ el.classList.add('show'); }); }, 60);

      if (tabsEl) {
        tabsEl.querySelectorAll('a').forEach(function(a){
          a.addEventListener('click', function(){
            setTimeout(function(){ document.querySelectorAll('.fade-pane').forEach(function(el){ el.classList.add('show'); }); }, 80);
          });
        });
      }

      var scrollToTabs = function(){
        if(!tabsEl) return;
        var y = tabsEl.getBoundingClientRect().top + window.scrollY
                - (document.querySelector('nav')?.offsetHeight || 8);
        window.scrollTo({ top: y, behavior:'smooth' });
      };

      document.querySelectorAll('nav a[href^=\"#\"]').forEach(function(a){
        a.addEventListener('click', function(ev){
          var id = (this.getAttribute('href')||'').replace('#','');
          if(!id || !tabsInstance) return;
          ev.preventDefault(); tabsInstance.select(id); scrollToTabs();
        });
      });

      document.querySelectorAll('#mobile-menu a[href^=\"#\"]').forEach(function(a){
        a.addEventListener('click', function(ev){
          var id = (this.getAttribute('href')||'').replace('#','');
          if(!id || !tabsInstance) return;
          ev.preventDefault(); tabsInstance.select(id);
          var sn = M.Sidenav.getInstance(document.getElementById('mobile-menu'));
          if(sn) sn.close(); scrollToTabs();
        });
      });

      var toTopBtn = document.getElementById('to-top');
      if (toTopBtn) {
        toTopBtn.addEventListener('click', function(ev){
          ev.preventDefault(); window.scrollTo({ top: 0, behavior: 'smooth' });
        });
        var toggleToTop = function(){
          if (window.scrollY > 240) toTopBtn.classList.add('show');
          else toTopBtn.classList.remove('show');
        };
        toggleToTop(); window.addEventListener('scroll', toggleToTop, { passive: true });
      }
    });
  "), defer=NA),
  
  # ===== Header =====
  tags$nav(
    div(class="nav-wrapper teal",
        div(class="container",
            tags$a(href="#home", class="brand-logo", "Kamimura Daichi"),
            tags$ul(class="right hide-on-med-and-down",
                    tags$li(tags$a(href="#home",    tags$i(class="material-icons left", "home"),   "Home")),
                    tags$li(tags$a(href="#works",   tags$i(class="material-icons left", "work"),   "Works")),
                    tags$li(tags$a(href="#about",   tags$i(class="material-icons left", "person"), "About")),
                    tags$li(tags$a(href="#product",
                                   tags$i(class="material-icons left", "apps"),   "App"))
            ),
            tags$a(href="#", class="sidenav-trigger right hide-on-large-only",
                   `data-target`="mobile-menu",
                   tags$i(class="material-icons", "menu"))
        )
    )
  ),
  
  tags$ul(id="mobile-menu", class="sidenav right-aligned",
          tags$li(tags$a(href="#home",    tags$i(class="material-icons left", "home"),   "Home")),
          tags$li(tags$a(href="#works",   tags$i(class="material-icons left", "work"),   "Works")),
          tags$li(tags$a(href="#about",   tags$i(class="material-icons left", "person"), "About")),
          tags$li(tags$a(href="#product",
                         tags$i(class="material-icons left", "apps"),   "App"))
  ),
  
  div(
    tags$ul(class="tabs",
            tags$li(class="tab", tags$a(href="#home",    "HOME")),
            tags$li(class="tab", tags$a(href="#works",   "WORKS")),
            tags$li(class="tab", tags$a(href="#about",   "ABOUT")),
            tags$li(class="tab", tags$a(href="#product", "APP"))
    )
  ),
  
  # ===== Home =====
  ## （以下は前回と同じなので省略なくそのまま残しています）
  div(id="home", class="container",
      div(class="fade-pane",
          div(class="hero",
              div(class="row valign-wrapper",
                  div(class="col s12 m2 center",
                      tags$img(src="img/raccoon.jpg",
                               class="avatar", alt="プロフィール画像",
                               loading="eager", decoding="async", width="96", height="96")
                  ),
                  div(class="col s12 m10",
                      tags$h4("Hi, I'm Kamimura Daichi"),
                      p("データ分析と R/Shiny を使ったインタラクティブな可視化が好きです。",
                        "心理統計の知見を、実務で誰でも使えるWebアプリケーションまで落とし込むことを目指しています。"),
                      div(class="chips",
                          span(class="chip","R/Shiny"),
                          span(class="chip","Data Visualization"),
                          span(class="chip","Psychometrics"),
                          span(class="chip","MDS"),
                          span(class="chip","Questionnaire Design"),
                          span(class="chip","Scale Development"),
                          span(class="chip","Text Mining"),
                          span(class="chip","Genetic Algorithm")
                      ),
                      tags$br(),
                      div(class="btn-flex home-cta",
                          tags$a(href="#about",
                                 class="btn waves-effect waves-light teal",
                                 tags$i(class="material-icons left", "person"), "プロフィール"),
                          tags$a(href="#works",
                                 class="btn waves-effect waves-light white teal-text text-darken-2",
                                 style="border:1px solid rgba(0,0,0,.12);",
                                 tags$i(class="material-icons left", "work"), "作品"),
                          tags$a(href="#product",
                                 class="btn waves-effect waves-light white teal-text text-darken-2",
                                 style="border:1px solid rgba(0,0,0,.12);",
                                 tags$i(class="material-icons left", "apps"), "アプリ")
                      )
                  )
              )
          ),
          
          tags$h5(tags$i(class="material-icons tiny", "link"), " SNS / Links"),
          div(class="row",
              div(class="col s12 m6 l3",
                  tags$a(class="superlink", href="https://github.com/castella3", target="_blank", rel="noopener",
                         tags$i(class="material-icons", "code"),
                         div(tags$div("GitHub", style="font-weight:700;"),
                             tags$div(span(class="nowrap-block","コード・リポジトリ"), class="muted")))
              ),
              div(class="col s12 m6 l3",
                  tags$a(class="superlink", href="https://x.com/dkamimura0", target="_blank", rel="noopener",
                         tags$i(class="material-icons", "chat"),
                         div(tags$div("X (Twitter)", style="font-weight:700;"),
                             tags$div("日々のメモ", class="muted")))
              ),
              div(class="col s12 m6 l3",
                  tags$a(class="superlink", href="https://www.linkedin.com/in/yourname", target="_blank", rel="noopener",
                         tags$i(class="material-icons", "badge"),
                         div(tags$div("LinkedIn", style="font-weight:700;"),
                             tags$div("経歴・スキル", class="muted")))
              ),
              div(class="col s12 m6 l3",
                  tags$a(class="superlink", href="mailto:you@example.com",
                         tags$i(class="material-icons", "mail"),
                         div(tags$div("Email", style="font-weight:700;"),
                             tags$div("kamimura202047@gmail.com", class="muted")))
              )
          ),
          tags$br(), tags$br()
      )
  ),
  
  # ===== Works / About / Product / Footer =====
  ## （このあとの部分は、前回お渡ししたコードと同一です）
  ## 省略せず貼り直した方がよければ、続きも丸ごと出します！
  
)

server <- function(input, output, session) { }

shinyApp(ui, server)
