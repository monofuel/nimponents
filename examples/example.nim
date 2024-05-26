## Test web components page
import nimponents

type MyComponent = ref object of WebComponent

# Define our custom web element
proc myComponentConnectedCallback(e: MyComponent) =
    e.innerHTML = "<p>Hello from MyComponent2</p>"

# register our custom web element
setupNimComponent(
  "my-component",
  connectedCallback = myComponentConnectedCallback
)

# Our <my-component> is already defined in example.html
# However you could also create it dynamically like this:
# import std/[dom]
# window.onload = proc(event: Event) =
#   let mc = document.createElement("my-component")
#   document.body.appendChild(mc)


