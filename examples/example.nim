## Test web components page
import std/[dom, jsffi], nimponents

# Define our custom web element
proc newMyComponent(e: WebComponent): Nimponent =
  result = Nimponent()
  result.self = e
  result.connectedCallback = proc() =
    e.innerHTML = "<p>Hello from MyComponent2</p>"

# register our custom web element
setupNimComponent("my-component", newMyComponent)


# Our <my-component> is already defined in example.html
# However you could also create it dynamically like this:
# window.onload = proc(event: Event) =
#   let mc = document.createElement("my-component")
#   document.body.appendChild(mc)


