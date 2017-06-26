defmodule LcsStats.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def websocket_urls do
    [
      # NA 1
      "ws://livestats.proxy.lolesports.com/stats?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2IjoiMS4wIiwiamlkIjoiOWMyM2NjYWUtOGJhMy00NDI2LTk5NTgtMmZkNzgyOGVlMDVhIiwiaWF0IjoxNDk4MjYxMjcxMDMyLCJleHAiOjE0OTg4NjYwNzEwMzIsIm5iZiI6MTQ5ODI2MTI3MTAzMiwiY2lkIjoiYTkyNjQwZjI2ZGMzZTM1NGI0MDIwMjZhMjA3NWNiZjMiLCJzdWIiOnsiaXAiOiIxMDguNDkuMTM5LjEyMSIsInVhIjoiTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTJfNSkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzU4LjAuMzAyOS4xMTAgU2FmYXJpLzUzNy4zNiJ9LCJyZWYiOlsid2F0Y2guKi5sb2xlc3BvcnRzLmNvbSJdLCJzcnYiOlsibGl2ZXN0YXRzLXYxLjAiXX0.0S3crVALjbrwDk7u7HYI27ygxWgqZ5QSbNhEIbtX-0A",
      #NA 2
      "ws://livestats.proxy.lolesports.com/stats?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2IjoiMS4wIiwiamlkIjoiZmU4NDIyYTgtY2RmMS00YWE0LTlhYzgtY2RjZjEwM2I1MTg1IiwiaWF0IjoxNDk4NDIxNDMxMDI3LCJleHAiOjE0OTkwMjYyMzEwMjcsIm5iZiI6MTQ5ODQyMTQzMTAyNywiY2lkIjoiYTkyNjQwZjI2ZGMzZTM1NGI0MDIwMjZhMjA3NWNiZjMiLCJzdWIiOnsiaXAiOiIyMDkuNi41NS43MCIsInVhIjoiTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTJfNSkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzU4LjAuMzAyOS4xMTAgU2FmYXJpLzUzNy4zNiJ9LCJyZWYiOlsid2F0Y2guKi5sb2xlc3BvcnRzLmNvbSJdLCJzcnYiOlsibGl2ZXN0YXRzLXYxLjAiXX0.3HNP_6JFU88yeMm-QAch8yZmInMpv_LMK5G3dKqqkXc",
      # EU (only 1)
      "ws://livestats.proxy.lolesports.com/stats?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2IjoiMS4wIiwiamlkIjoiY2M3ZTI2M2QtZjkwMy00OWUyLWE4ZjgtZjAwZjI1N2Y2YWI3IiwiaWF0IjoxNDk3MjAzNzIyMjg1LCJleHAiOjE0OTc4MDg1MjIyODUsIm5iZiI6MTQ5NzIwMzcyMjI4NSwiY2lkIjoiYTkyNjQwZjI2ZGMzZTM1NGI0MDIwMjZhMjA3NWNiZjMiLCJzdWIiOnsiaXAiOiIyMDkuNi41NS43MCIsInVhIjoiTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTJfNSkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzU4LjAuMzAyOS4xMTAgU2FmYXJpLzUzNy4zNiJ9LCJyZWYiOlsid2F0Y2guKi5sb2xlc3BvcnRzLmNvbSJdLCJzcnYiOlsibGl2ZXN0YXRzLXYxLjAiXX0.OTwFuh8cRcTemXybQRn3qMu4p0Pza4WCH8s7cJcUN-E"
    ]
  end

  def init([]) do
    children = [
      worker(LcsStats.Publisher, [], [])
    ]
    children = Enum.into(websocket_urls(), children, fn (url) ->
      worker(LcsStats.WebSocketReader, [url], [id: url])
    end)

    # supervise/2 is imported from Supervisor.Spec
    supervise(children, strategy: :one_for_one)
  end
end
