## Test web components page
import nimponents

type MyComponent = ref object of WebComponent

# Define our custom web element
proc constructor(e: MyComponent) =
    echo "MyComponent created"

proc connectedCallback(e: MyComponent) =
    e.innerHTML = "<p>Hello from MyComponent2</p>"

proc disconnectedCallback(e: MyComponent) =
    echo "MyComponent disconnected"

proc adoptedCallback(e: MyComponent) =
    echo "MyComponent adopted"

proc attributeChangedCallback(e: MyComponent; name: string; oldValue: string; newValue: string) =
    echo "MyComponent attribute changed: ", name, " ", oldValue, " ", newValue

# register our custom web element
setupNimponent("my-component",
  constructor,
  connectedCallback,
  disconnectedCallback,
  adoptedCallback,
  attributeChangedCallback
)

# Our <my-component> is already defined in example.html
# However you could also create it dynamically like this:
# import std/[dom]
# window.onload = proc(event: Event) =
#   let mc = document.createElement("my-component")
#   document.body.appendChild(mc)


