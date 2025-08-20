
when defined(postgre):
  switch("define", "nimDebugDlOpen")
  # switch("passL",gorge("pkgconf --libs libpq"))
  switch("passL","-L/opt/homebrew/lib/postgresql@14")
  switch("passL","-Wl,-rpath,/opt/homebrew/lib/postgresql@14")
  # switch("passL", "-L/opt/homebrew/lib -Wl,-rpath,/opt/homebrew/lib/")

