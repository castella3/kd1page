# install.packages("shinylive")  # 初回のみibrary(shinylive)
# shinylive::export(appdir = "myapp", destdir = "docs")
# shinylive::export(
#   appdir  = "myapp",   # app.R が入っているフォルダ
#   destdir = "docs",    # GitHub Pages 用のフォルダ
#   template_params = list(
#     # ここがブラウザのタブ名になる
#     title = "Daichi Kamimura | R/Shiny Portfolio – powered by Shiny"
#     
#   )
# )

library(shinylive)

# 1. app を docs に書き出し
shinylive::export(
  appdir = "myapp",
  destdir = "docs",
  template_params = list(
    # ← タイトルはここで上書きする（前やったのと同じ）
    title = "上村大地 | ポートフォリオ",
    # ← ここで index.html の <head> に生HTMLを差し込める
    include_in_head = '
<link rel="icon" type="image/jpeg" href="raccoon.jpg">
<link rel="apple-touch-icon" href="raccoon.jpg">
'
  )
)

# 2. favicon 用に、画像を docs/ にコピー
file.copy(
  from = "myapp/www/img/raccoon.jpg",
  to   = "docs/raccoon.jpg",
  overwrite = TRUE
)


# install.packages("servr")   # 未インストールなら

free_port <- httpuv::randomPort()
servr::httd(dir = "docs", port = free_port, daemon = FALSE, browser = TRUE)
# 例：固定でいくなら 8088 や 8010 など
# servr::httd("docs", port = 8088, daemon = FALSE, browser = TRUE)

# git add docs/
# git commit -m "add shinylive docs"
# git push