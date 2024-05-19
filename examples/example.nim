## Test web components page
import std/[dom, jsffi], nimponents


type
  MyComponent = ref object of WebComponent

proc newMyComponent(e: WebComponent): Nimponent =
  result = Nimponent()
  result.self = e
  result.connectedCallback = proc() =
    e.innerHTML = "<p>Hello from MyComponent2</p>"

proc init(event: Event) =
  echo "Init"
  setupNimComponent("my-component", newMyComponent)
  let mc = document.createElement("my-component")
  document.body.appendChild(mc)
  echo "added test component to body"

window.onload = init

