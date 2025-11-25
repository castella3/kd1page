# app.R — Materialize + Icons / レスポンシブ版
# フッターを横スクロールさせず、幅に応じて折り返し表示
# 画像: www/img/raccoon.jpg, work_lnre.jpg, work_capture.jpg, app_preview.jpg
# 発表資料（例）: www/docs/tokyor_2024_saturation.pdf, www/docs/tokyor_2024_handson.html

library(shiny)

pro_url <- "https://your-pro-app.example"
utm_nav <- paste0(pro_url, "?utm_source=portfolio&utm_medium=nav&utm_campaign=app_cta")
utm_body <- paste0(pro_url, "?utm_source=portfolio&utm_medium=body&utm_campaign=app_cta")


# 言語切り替え用ヘルパー関数
txt <- function(ja, en) {
  tagList(
    span(class = "lang-ja", ja),
    span(class = "lang-en", en)
  )
}

ui <- fluidPage(
  title = "上村大地 | ポートフォリオ",
  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"),
    tags$script(src = "https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"),
    tags$link(href = "https://fonts.googleapis.com/icon?family=Material+Icons", rel = "stylesheet"),
    tags$link(rel = "icon", href = "img/raccoon.jpg?v=7", type = "image/jpeg"),
    tags$style(HTML("
      body { letter-spacing:.2px; }
      .brand-logo { font-weight:700; white-space:nowrap; font-size:28px; }
      @media (max-width:1200px){ .brand-logo { font-size:24px; } }
      @media (max-width:992px) { .brand-logo { font-size:22px; } }
      @media (max-width:600px) { .brand-logo { font-size:20px; } }

      .hero {
        border-radius:18px; padding:24px;
        background: linear-gradient(135deg, #e0f2f1 0%, #80cbc4 100%);
        box-shadow:0 16px 48px rgba(0,0,0,.08);
        margin-top:18px;
        position: relative;
        overflow: hidden;
      }
      #particles-js {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        z-index: 0;
      }
      .hero .container {
        position: relative;
        z-index: 1;
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
      .superlink .muted { letter-spacing:0; overflow-wrap:anywhere; line-height:1.2; }
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

      .site-footer { background:#009688; color:#e0f2f1; padding:10px 0; margin-top:28px; }
      .footer-row { display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap; }
      .footer-copy { font-weight:600; letter-spacing:.2px; }
      .footer-links { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
      .footer-chip { display:inline-flex; align-items:center; gap:6px; padding:6px 10px; border-radius:999px;
                     background:rgba(255,255,255,.08); color:#e0f2f1; border:1px solid rgba(255,255,255,.16);
                     text-decoration:none; font-weight:600; font-size:13px; white-space:nowrap; }
      .footer-chip:hover { background:rgba(255,255,255,.14); }
      .footer-chip i { font-size:18px; line-height:1; }

      @media (max-width:600px){
        .footer-row { flex-direction:column; align-items:flex-start; gap:8px; }
      }

      .nowrap-block { display:inline-block; white-space:nowrap; }

      body.ja-mode .lang-en { display: none !important; }
      body.en-mode .lang-ja { display: none !important; }
    "))
  ),
  tags$script(HTML("
    document.addEventListener('DOMContentLoaded', function(){
      document.body.classList.add('ja-mode');
      var langBtn = document.getElementById('lang-toggle');
      if(langBtn){
        langBtn.addEventListener('click', function(e){
          e.preventDefault();
          if(document.body.classList.contains('ja-mode')){
            document.body.classList.remove('ja-mode');
            document.body.classList.add('en-mode');
            this.innerText = 'JP';
          } else {
            document.body.classList.remove('en-mode');
            document.body.classList.add('ja-mode');
            this.innerText = 'EN';
          }
        });
      }

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
        var y = tabsEl.getBoundingClientRect().top + window.scrollY - (document.querySelector('nav')?.offsetHeight || 8);
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

      // Particles.js Initialization
      if(document.getElementById('particles-js')){
        particlesJS('particles-js', {
          'particles': {
            'number': { 'value': 80, 'density': { 'enable': true, 'value_area': 800 } },
            'color': { 'value': '#ffffff' },
            'shape': { 'type': 'circle' },
            'opacity': { 'value': 0.5, 'random': false },
            'size': { 'value': 3, 'random': true },
            'line_linked': { 'enable': true, 'distance': 150, 'color': '#ffffff', 'opacity': 0.4, 'width': 1 },
            'move': { 'enable': true, 'speed': 2, 'direction': 'none', 'random': false, 'straight': false, 'out_mode': 'out', 'bounce': false }
          },
          'interactivity': {
            'detect_on': 'canvas',
            'events': {
              'onhover': { 'enable': true, 'mode': 'grab' },
              'onclick': { 'enable': true, 'mode': 'push' },
              'resize': true
            },
            'modes': {
              'grab': { 'distance': 140, 'line_linked': { 'opacity': 1 } },
            }
          },
          'retina_detect': true
        });
      }
    });

  ")),

  # ===== Header =====
  tags$nav(
    div(
      class = "nav-wrapper teal",
      div(
        class = "container",
        tags$a(href = "#home", class = "brand-logo", "Kamimura Daichi"),
        tags$ul(
          class = "right hide-on-med-and-down",
          tags$li(tags$a(href = "#home", tags$i(class = "material-icons left", "home"), txt("Home", "Home"))),
          tags$li(tags$a(href = "#works", tags$i(class = "material-icons left", "work"), txt("Works", "Works"))),
          tags$li(tags$a(href = "#about", tags$i(class = "material-icons left", "person"), txt("About", "About"))),
          tags$li(tags$a(
            href = "#product",
            tags$i(class = "material-icons left", "apps"), txt("App", "App")
          )),
          tags$li(tags$a(href = "#", id = "lang-toggle", style = "font-weight:bold; border:1px solid rgba(255,255,255,0.5); padding:0 10px; margin-left:10px; line-height:32px; height:34px; margin-top:15px; border-radius:4px;", "EN"))
        ),
        tags$a(
          href = "#", class = "sidenav-trigger right hide-on-large-only",
          `data-target` = "mobile-menu",
          tags$i(class = "material-icons", "menu")
        )
      )
    )
  ),
  tags$ul(
    id = "mobile-menu", class = "sidenav right-aligned",
    tags$li(tags$a(href = "#home", tags$i(class = "material-icons left", "home"), "Home")),
    tags$li(tags$a(href = "#works", tags$i(class = "material-icons left", "work"), "Works")),
    tags$li(tags$a(href = "#about", tags$i(class = "material-icons left", "person"), "About")),
    # ★モバイルメニューのAppも外部リンク → #product へ
    tags$li(tags$a(
      href = "#product",
      tags$i(class = "material-icons left", "apps"), txt("App", "App")
    ))
  ),
  div(
    tags$ul(
      class = "tabs",
      tags$li(class = "tab", tags$a(href = "#home", "HOME")),
      tags$li(class = "tab", tags$a(href = "#works", "WORKS")),
      tags$li(class = "tab", tags$a(href = "#about", "ABOUT")),
      tags$li(class = "tab", tags$a(href = "#product", "APP"))
    )
  ),

  # ===== Home =====
  div(
    id = "home", class = "container",
    div(
      class = "fade-pane",
      div(
        class = "hero",
        div(id = "particles-js"),
        div(
          class = "row valign-wrapper",
          div(
            class = "col s12 m2 center",
            tags$img(
              src = "img/raccoon.jpg",
              class = "avatar", alt = "プロフィール画像",
              loading = "eager", decoding = "async", width = "96", height = "96"
            )
          ),
          div(
            class = "col s12 m10",
            tags$h4(txt("Hi, I'm Kamimura Daichi", "Hi, I'm Kamimura Daichi")),
            p(
              txt("データ分析と R/Shiny を使ったインタラクティブな可視化が好きです。", "I love interactive visualization using Data Analysis and R/Shiny."),
              txt("心理統計の知見を、実務で誰でも使えるWebアプリケーションまで落とし込むことを目指しています。", "I aim to translate insights from psychometrics into web applications that anyone can use in practice.")
            ),
            div(
              class = "chips",
              span(class = "chip", "R/Shiny"),
              span(class = "chip", "Data Visualization"),
              span(class = "chip", "Psychometrics"),
              span(class = "chip", "MDS"),
              span(class = "chip", "Questionnaire Design"),
              span(class = "chip", "Scale Development"),
              span(class = "chip", "Text Mining"),
              span(class = "chip", "Genetic Algorithm")
            ),
            tags$br(),
            div(
              class = "btn-flex home-cta",
              tags$a(
                href = "#about",
                class = "btn waves-effect waves-light teal",
                tags$i(class = "material-icons left", "person"), txt("プロフィール", "Profile")
              ),
              tags$a(
                href = "#works",
                class = "btn waves-effect waves-light white teal-text text-darken-2",
                style = "border:1px solid rgba(0,0,0,.12);",
                tags$i(class = "material-icons left", "work"), txt("作品", "Works")
              ),
              tags$a(
                href = "#product",
                class = "btn waves-effect waves-light white teal-text text-darken-2",
                style = "border:1px solid rgba(0,0,0,.12);",
                tags$i(class = "material-icons left", "apps"), txt("アプリ", "App")
              )
            )
          )
        )
      ),
      tags$h5(tags$i(class = "material-icons tiny", "link"), " SNS / Links"),
      div(
        class = "row",
        div(
          class = "col s12 m6 l3",
          tags$a(
            class = "superlink", href = "https://github.com/castella3", target = "_blank", rel = "noopener",
            tags$i(class = "material-icons", "code"),
            div(
              tags$div("GitHub", style = "font-weight:700;"),
              tags$div(span(class = "nowrap-block", txt("コード・リポジトリ", "Code Repository")), class = "muted")
            )
          )
        ),
        div(
          class = "col s12 m6 l3",
          tags$a(
            class = "superlink", href = "https://x.com/dkamimura0", target = "_blank", rel = "noopener",
            tags$i(class = "material-icons", "chat"),
            div(
              tags$div("X (Twitter)", style = "font-weight:700;"),
              tags$div(txt("日々のメモ", "Daily Notes"), class = "muted")
            )
          )
        ),
        div(
          class = "col s12 m6 l3",
          tags$a(
            class = "superlink", href = "https://www.linkedin.com/in/daichi-kamimura", target = "_blank", rel = "noopener",
            tags$i(class = "material-icons", "badge"),
            div(
              tags$div("LinkedIn", style = "font-weight:700;"),
              tags$div(txt("経歴・スキル", "Career & Skills"), class = "muted")
            )
          )
        ),
        div(
          class = "col s12 m6 l3",
          tags$a(
            class = "superlink", href = "mailto:you@example.com",
            tags$i(class = "material-icons", "mail"),
            div(
              tags$div("Email", style = "font-weight:700;"),
              tags$div("kamimura202047@gmail.com", class = "muted")
            )
          )
        )
      ),
      tags$br(), tags$br()
    )
  ),

  # ===== Works =====
  div(
    id = "works", class = "container",
    div(
      class = "fade-pane",
      tags$h4(tags$i(class = "material-icons", "work"), txt(" 作品", " Works")),
      div(
        class = "row",
        div(
          class = "col s12 m6",
          div(
            class = "card hoverable",
            div(
              class = "card-image",
              tags$img(
                src = "img/work_lnre.jpg", alt = "LNRE 可視化ダッシュボード",
                class = "responsive-img work-thumb", loading = "lazy", decoding = "async"
              )
            ),
            div(
              class = "card-content",
              div(class = "work-title", txt("LNRE 可視化ダッシュボード", "LNRE Visualization Dashboard")),
              p(txt("語彙成長（VGC）や EV 曲線をインタラクティブに確認し、収集の打ち止め時期を検討できる UI。", "UI to interactively check Vocabulary Growth Curves (VGC) and EV curves to determine when to stop data collection."))
            ),
            div(
              class = "card-action",
              tags$a(href = "#product", class = "teal-text text-darken-2", txt("アプリを見る", "View App"))
            )
          )
        ),
        div(
          class = "col s12 m6",
          div(
            class = "card hoverable",
            div(
              class = "card-image",
              tags$img(
                src = "img/work_capture.jpg", alt = "再捕獲法の指標比較",
                class = "responsive-img work-thumb", loading = "lazy", decoding = "async"
              )
            ),
            div(
              class = "card-content",
              div(class = "work-title", txt("再捕獲法の指標比較ツール", "Capture-Recapture Metrics Comparison")),
              p(txt("Chapman 推定など複数指標を並行比較できる小ツール。推定の幅や前提の違いを直感的に確認。", "A small tool to compare multiple metrics like Chapman estimation. Intuitively check the range of estimates and differences in assumptions."))
            ),
            div(
              class = "card-action",
              tags$a(href = "https://github.com/castella3", target = "_blank", rel = "noopener", "GitHub")
            )
          )
        )
      )
    )
  ),

  # ===== About =====
  div(
    id = "about", class = "container",
    div(
      class = "fade-pane",
      tags$h4(tags$i(class = "material-icons", "person"), txt(" プロフィール", " Profile")),
      div(
        class = "about-hero",
        div(
          class = "row valign-wrapper",
          div(
            class = "col s12 m3 center",
            tags$img(src = "img/raccoon.jpg", class = "avatar-lg", alt = "プロフィール画像", loading = "lazy", decoding = "async")
          ),
          div(
            class = "col s12 m9",
            tags$h5(
              style = "font-weight:800; margin:0 0 8px;",
              txt("R/Shiny を使ったデータ可視化・プロトタイピングが得意です", "Specializing in Data Visualization and Prototyping with R/Shiny")
            ),
            p(
              class = "muted",
              txt("来年から就職予定。大学院では心理統計の知見を活かし、", "Starting a new job next year. In graduate school, leveraging insights from psychometrics,"),
              txt("テキストデータの飽和推定とインタラクティブな可視化アプリを制作してきました。", "I have been creating interactive visualization apps for estimating text data saturation."),
              txt("実務では“数値の根拠が伝わる UI”づくりで貢献したいと考えています。", "In practice, I aim to contribute by creating UIs that convey the basis of numbers.")
            ),
            div(
              class = "tag-cloud",
              span(class = "chip", "R/Shiny"),
              span(class = "chip", "Data Visualization"),
              span(class = "chip", "Psychometrics"),
              span(class = "chip", "MDS"),
              span(class = "chip", "Questionnaire Design"),
              span(class = "chip", "Scale Development"),
              span(class = "chip", "Text Mining"),
              span(class = "chip", "Genetic Algorithm")
            ),
            div(class = "about-divider")
          )
        ),
        div(
          class = "stat-grid",
          div(
            class = "stat-card", tags$i(class = "material-icons", "insights"),
            div(
              div(class = "stat-title", txt("要件を“画で見せる”に変換", "Visualizing Requirements")),
              div(class = "stat-sub", txt("分析結果をUIに落とし込み、意思決定につながる画面へ。", "Translating analysis results into UIs that lead to decision-making."))
            )
          ),
          div(
            class = "stat-card", tags$i(class = "material-icons", "auto_graph"),
            div(
              div(class = "stat-title", txt("統計の土台あり", "Statistical Foundation")),
              div(class = "stat-sub", txt("心理統計の知識を踏まえたモデリング/評価。", "Modeling and evaluation based on knowledge of psychometrics."))
            )
          ),
          div(
            class = "stat-card", tags$i(class = "material-icons", "code"),
            div(
              div(class = "stat-title", txt("素早い試作", "Rapid Prototyping")),
              div(class = "stat-sub", txt("R/Shiny で要件ヒアリング→試作→改善のサイクルを短縮。", "Shortening the cycle of requirement hearing -> prototyping -> improvement with R/Shiny."))
            )
          ),
          div(
            class = "stat-card", tags$i(class = "material-icons", "groups"),
            div(
              div(class = "stat-title", txt("伝わる説明", "Clear Explanation")),
              div(class = "stat-sub", txt("誰にでも伝わるコピーとサンプルで実装。", "Implemented with copy and samples that anyone can understand."))
            )
          )
        )
      ),
      tags$br(),
      tags$h5(tags$i(class = "material-icons tiny", "schedule"), " Timeline"),
      div(
        class = "timeline",
        div(
          class = "tl-item",
          div(class = "tl-meta", "2026"),
          div(class = "tl-title", txt("楽天へ就職", "Joining Rakuten")),
          p(class = "muted", txt("FinTec分野でデータコンサルタントとして従事。", "Working as a Data Consultant in the FinTech field."))
        ),
        div(
          class = "tl-item",
          div(class = "tl-meta", "2025"),
          div(class = "tl-title", txt("修論:自由記述アンケートの飽和に関する研究", "Master's Thesis: Research on Saturation in Open-ended Surveys")),
          p(class = "muted", txt("LNREモデルを用いた新しい指標の提案。", "Proposing new metrics using LNRE models."))
        ),
        div(
          class = "tl-item",
          div(class = "tl-meta", "2024"),
          div(class = "tl-title", txt("大学卒業後、大学院へ進学", "Entered Graduate School after University")),
          p(class = "muted", txt("データ分析に携わる仕事に就くことを目標に技術と知識を深める。", "Deepening skills and knowledge with the goal of working in data analysis."))
        ),
        div(
          class = "tl-item",
          div(class = "tl-meta", "2023"),
          div(class = "tl-title", txt("卒論:ディズニーランドにおける満足度の高い経路探索アルゴリズムの開発", "Bachelor's Thesis: Route Search Algorithm for High Satisfaction at Disneyland")),
          p(class = "muted", txt("遺伝的アルゴリズムを用いて満足度を最大化させるルート探索アルゴリズム。日本心理学会のプレゼンバトルで発表。", "Route search algorithm maximizing satisfaction using Genetic Algorithms. Presented at the Japanese Psychological Association presentation battle."))
        ),
        div(
          class = "tl-item",
          div(class = "tl-meta", "2022"),
          div(class = "tl-title", txt("心理統計学に魅了され、統計ゼミに入る", "Fascinated by Psychometrics, Joined Statistics Seminar")),
          p(class = "muted", txt("データ分析のコンペティション大会に参加。Rの技術を深める。", "Participated in data analysis competitions. Deepened R skills."))
        ),
        div(
          class = "tl-item",
          div(class = "tl-meta", "2020"),
          div(class = "tl-title", txt("心理学を学ぶために大学へ進学", "Entered University to Study Psychology")),
          p(class = "muted", txt("脳科学に興味があり、心理学部に進む。Rに出会う。", "Interested in Neuroscience, entered the Faculty of Psychology. Encountered R."))
        )
      ),
      tags$br(),
      tags$ul(
        class = "collapsible",
        tags$li(
          div(class = "collapsible-header", tags$i(class = "material-icons", "expand_more"), txt("発表資料・リンク（デモ）", "Presentations & Links (Demo)")),
          div(
            class = "collapsible-body",
            tags$ul(
              tags$li(
                HTML('<i class="material-icons tiny" style="color:#26a69a">picture_as_pdf</i> '),
                span(
                  "Tokyo.R LT：テキスト飽和の概念と簡易推定（PDF） — ",
                  tags$a(href = "docs/tokyor_2024_saturation.pdf", target = "_blank", "tokyor_2024_saturation.pdf")
                )
              ),
              tags$li(
                HTML('<i class="material-icons tiny" style="color:#26a69a">slideshow</i> '),
                span(
                  "Tokyo.R ハンズオン：VGC/EV を R で触る（HTML スライド） — ",
                  tags$a(href = "docs/tokyor_2024_handson.html", target = "_blank", "tokyor_2024_handson.html")
                )
              ),
              tags$li(
                HTML('<i class="material-icons tiny" style="color:#26a69a">link</i> '),
                span(
                  txt("connpass イベントページ（外部） — ", "connpass Event Page (External) — "),
                  tags$a(href = "https://tokyor.connpass.com/", target = "_blank", rel = "noopener", "Tokyo.R")
                )
              )
            )
          )
        )
      ),
      tags$br(),
      div(
        class = "btn-flex app-cta",
        tags$a(
          href = "https://x.com/dkamimura0", target = "_blank", rel = "noopener",
          class = "btn waves-effect waves-light white teal-text text-darken-2",
          style = "border:1px solid rgba(0,0,0,.12);",
          tags$i(class = "material-icons left", "chat"), txt("X (Twitter)を見る", "View X (Twitter)")
        ),
        tags$a(
          href = "https://github.com/castella3", target = "_blank", rel = "noopener",
          class = "btn waves-effect waves-light white teal-text text-darken-2",
          style = "border:1px solid rgba(0,0,0,.12);",
          tags$i(class = "material-icons left", "code"), txt("GitHubを見る", "View GitHub")
        ),
        tags$a(
          href = "https://www.linkedin.com/in/daichi-kamimura", target = "_blank", rel = "noopener",
          class = "btn waves-effect waves-light white teal-text text-darken-2",
          style = "border:1px solid rgba(0,0,0,.12);",
          tags$i(class = "material-icons left", "badge"), txt("LinkedInを見る", "View LinkedIn")
        ),
        tags$a(
          href = "mailto:you@example.com?subject=Contact%20from%20Portfolio",
          class = "btn waves-effect waves-light white teal-text text-darken-2",
          style = "border:1px solid rgba(0,0,0,.12);",
          tags$i(class = "material-icons left", "mail"), txt("メールで連絡", "Contact via Email")
        )
      )
    )
  ),

  # ===== Product =====
  div(
    id = "product", class = "container",
    div(
      class = "fade-pane",
      div(
        class = "hero",
        div(
          class = "row",
          div(
            class = "col s12 m8",
            tags$div(class = "pill", "NEW"),
            tags$h4(txt("有料分析アプリ — テキストの飽和や語彙成長を高速推定", "Paid Analysis App — Fast Estimation of Text Saturation and Vocabulary Growth")),
            p(
              class = "muted",
              txt("自由記述データの量をどこまで集めればよいか？ ", "How much open-ended data should be collected? "),
              txt("LNRE（fZM）や再捕獲アプローチを併用し、飽和到達点やVGCを可視化・推定します。", "Using LNRE (fZM) and capture-recapture approaches to visualize and estimate saturation points and VGC.")
            ),
            div(
              class = "btn-flex app-cta",
              tags$a(
                href = utm_body, target = "_blank", rel = "noopener",
                class = "btn waves-effect waves-light teal",
                tags$i(class = "material-icons left", "launch"), txt("今すぐ使ってみる", "Try it Now")
              ),
              tags$a(
                href = utm_body, target = "_blank", rel = "noopener",
                class = "btn waves-effect waves-light white teal-text text-darken-2",
                style = "border:1px solid rgba(0,0,0,.12);",
                tags$i(class = "material-icons left", "open_in_new"), txt("ドキュメント / サンプルを見る", "Docs / Samples")
              )
            )
          ),
          div(
            class = "col s12 m4 center",
            tags$img(
              src = "img/app_preview.jpg", alt = "App preview",
              style = "max-width:100%; border-radius:12px; box-shadow:0 10px 24px rgba(0,0,0,.12);",
              loading = "lazy", decoding = "async"
            )
          )
        )
      ),
      tags$br(),
      tags$h5(txt("主な機能", "Key Features")),
      div(
        class = "row",
        div(
          class = "col s12 m6 l3",
          div(class = "card", div(
            class = "card-content",
            tags$i(class = "material-icons check", "check_circle"),
            tags$strong(txt(" 語彙成長 / EV曲線", " Vocabulary Growth / EV Curve")),
            p(class = "muted", txt("zipfRベースのVGC/EVで収束の様子を可視化。", "Visualize convergence with zipfR-based VGC/EV."))
          ))
        ),
        div(
          class = "col s12 m6 l3",
          div(class = "card", div(
            class = "card-content",
            tags$i(class = "material-icons check", "check_circle"),
            tags$strong(txt(" 飽和到達点推定", " Saturation Point Estimation")),
            p(class = "muted", txt("しきい値（例: slope<0.05）や有限母集団仮定で判断。", "Judged by threshold (e.g., slope < 0.05) or finite population assumption."))
          ))
        ),
        div(
          class = "col s12 m6 l3",
          div(class = "card", div(
            class = "card-content",
            tags$i(class = "material-icons check", "check_circle"),
            tags$strong(txt(" 再捕獲の指標比較", " Capture-Recapture Metrics")),
            p(class = "muted", txt("Chapman推定など複数指標を並行比較。", "Parallel comparison of multiple metrics like Chapman estimation."))
          ))
        ),
        div(
          class = "col s12 m6 l3",
          div(class = "card", div(
            class = "card-content",
            tags$i(class = "material-icons check", "check_circle"),
            tags$strong(txt(" レポート出力", " Report Export")),
            p(class = "muted", txt("図表をまとめてエクスポート（将来対応）。", "Export charts and tables (Future support)."))
          ))
        )
      ),
      tags$br(),
      div(
        class = "center",
        tags$a(
          href = utm_body, target = "_blank", rel = "noopener",
          class = "btn waves-effect waves-light teal",
          tags$i(class = "material-icons left", "rocket_launch"),
          txt("今すぐ使ってみる", "Try it Now")
        )
      )
    )
  ),

  # ===== Footer（折り返し・横スクロールなし） =====
  tags$footer(
    class = "site-footer",
    div(
      class = "container footer-row",
      div(
        class = "footer-copy",
        HTML(paste0("&copy; ", format(Sys.Date(), "%Y"), " Kamimura Daichi"))
      ),
      div(
        class = "footer-links",
        tags$a(
          href = "https://x.com/dkamimura0", target = "_blank", rel = "noopener",
          class = "footer-chip", `aria-label` = "X (Twitter)",
          tags$i(class = "material-icons", "chat"), span("X (Twitter)")
        ),
        tags$a(
          href = "https://github.com/castella3", target = "_blank", rel = "noopener",
          class = "footer-chip", `aria-label` = "GitHub",
          tags$i(class = "material-icons", "code"), span("GitHub")
        ),
        tags$a(
          href = "https://www.linkedin.com/in/daichi-kamimura", target = "_blank", rel = "noopener",
          class = "footer-chip", `aria-label` = "LinkedIn",
          tags$i(class = "material-icons", "badge"), span("LinkedIn")
        ),
        tags$a(
          href = "mailto:you@example.com", class = "footer-chip", `aria-label` = "Email",
          tags$i(class = "material-icons", "mail"), span("Email")
        )
      )
    )
  ),
  div(
    class = "fixed-action-btn",
    tags$a(
      id = "to-top", class = "btn-floating btn-large teal", href = "#", `aria-label` = "ページ上部へ戻る",
      tags$i(class = "large material-icons", "arrow_upward")
    )
  )
)

server <- function(input, output, session) { }

shinyApp(ui, server)
