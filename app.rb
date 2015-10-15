require "cuba"
require "cuba/render"
require "rack/protection"
require "digest/sha1"
require "base64"

Cuba.plugin(Cuba::Render)

Cuba.use(Rack::MethodOverride)
Cuba.use(
    Rack::Session::Cookie,
    key: "alert-app",
    secret: Digest::SHA1.hexdigest("alert-app" + Time.now.to_f.to_s)
  )

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

def send_alert(locals)
  res.headers["Content-Type"] = "image/svg+xml"
  res.headers["Cache-Control"] = "public, max-age=31536000, must-revalidate"
  res.headers["ETag"] = Digest::SHA1.hexdigest(req.fullpath)

  res.write partial("alert", locals)
end

Cuba.define do
  on get do
    on root do
      locals = { req: req }
      res.write partial("index", locals)
    end

    on "success.svg", param("message") do |message|
      locals = {
        type: "success",
        stroke: "#B5CFB5",
        fill: "#DFF0D8",
        text: "#326B31",
        icon: "#417505",
        message: message
      }

      send_alert(locals)
    end

    on "error.svg", param("message") do |message|
      locals = {
        type: "error",
        stroke: "#E9B4B4",
        fill: "#F5DEDE",
        text: "#A93538",
        icon: "#A93538",
        message: message
      }

      send_alert(locals)
    end

    on "info.svg", param("message") do |message|
      locals = {
        type: "info",
        stroke: "#B5CAE5",
        fill: "#E0E9F4",
        text: "#3060A3",
        icon: "#3060A3",
        message: message
      }

      send_alert(locals)
    end

    on "warning.svg", param("message") do |message|
      locals = {
        type: "warning",
        stroke: "#E8D7B1",
        fill: "#FCF8E3",
        text: "#8D6A32",
        icon: "#8D6A32",
        message: message
      }

      send_alert(locals)
    end
  end
end
