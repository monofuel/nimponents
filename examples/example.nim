## Test web components page
import nimponents

type MyComponent = ref object of WebComponent

# Define our custom web element
proc constructor(e: MyComponent) =
    ## the constructor is called when the component is created, but not yet mounted to the DOM.
    ## You probably don't want to do anything here as no DOM properties are available yet.
    ## Can be used for setting up internal state or a shadow DOM.
    echo "MyComponent created"

proc connectedCallback(e: MyComponent) =
    ## the connectedCallback is called when the component is mounted to the DOM.
    ## This is likely where you want to do your initial setup.
    ## You can read attributes here.
    e.innerHTML = "<p>Hello from MyComponent2</p>"

proc disconnectedCallback(e: MyComponent) =
    ## the disconnectedCallback is called when the component is removed from the DOM.
    ## This is where you clean things up.
    ## Make sure to clean up any event listeners, timers, intervals, global references, etc.
    echo "MyComponent disconnected"

proc adoptedCallback(e: MyComponent) =
    ## the adoptedCallback is called when the component is moved to a new document or across an iframe boundary.
    echo "MyComponent adopted"

proc attributeChangedCallback(e: MyComponent; name: cstring; oldValue: cstring; newValue: cstring) =
    ## Listen for attribute changes.
    echo "MyComponent attribute changed: ", $name, " ", $oldValue, " ", $newValue

# register our custom web element
setupNimponent("my-component",
  constructor,
  connectedCallback,
  disconnectedCallback,
  adoptedCallback,
  @["my-attr".cstring], # You have to provide a list of the attributes you want to listen for changes for.
  attributeChangedCallback
)

# Our <my-component> is already defined in example.html
# However you could also create it dynamically like this:
# import std/[dom]
# window.onload = proc(event: Event) =
#   let mc = document.createElement("my-component")
#   document.body.appendChild(mc)


