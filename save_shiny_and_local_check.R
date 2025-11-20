# install.packages("shinylive")  # 初回のみibrary(shinylive)
# shinylive::export(appdir = "myapp", destdir = "docs")
shinylive::export(
  appdir  = "myapp",   # app.R が入っているフォルダ
  destdir = "docs",    # GitHub Pages 用のフォルダ
  template_params = list(
    # ここがブラウザのタブ名になる
    title = "Daichi Kamimura | R/Shiny Portfolio – powered by Shiny"
    
  )
)
# install.packages("servr")   # 未インストールなら

free_port <- httpuv::randomPort()
servr::httd(dir = "docs", port = free_port, daemon = FALSE, browser = TRUE)
# 例：固定でいくなら 8088 や 8010 など
# servr::httd("docs", port = 8088, daemon = FALSE, browser = TRUE)

# git add docs/
# git commit -m "add shinylive docs"
# git push