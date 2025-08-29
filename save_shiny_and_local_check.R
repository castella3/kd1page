install.packages("shinylive")  # 初回のみibrary(shinylive)
shinylive::export(appdir = "myapp", destdir = "docs")

install.packages("servr")   # 初回のみ
servr::httd(dir = "docs", port = 8008, daemon = FALSE, browser = TRUE)
