## Test web components page
import std/[dom, jsffi]

type
  HTMLElement* {.importc.} = ref object of Element
  CustomElements* = ref object of RootObj
    define*: proc (name: cstring, elem: proc(): auto)

var customElements* {.importc: "customElements" .}: CustomElements

proc ComponentType(): auto {.exportc.} =
  echo "COMPONENT INIT"
  var self {.exportc.}: HTMLElement
  {.emit:["self = Reflect.construct(HTMLElement, [], new.target);"].}
  return self;

{.emit:["""
Object.setPrototypeOf(ComponentType.prototype, HTMLElement.prototype);
"""].}

proc HTMLElementCallbackImpl*(this: HtmlElement) =
  echo "Connected Callback"

  this.innerHTML = "<p>Hello from MyComponent2</p>"

let HTMLElementCallback {.exportc.} = bindMethod HTMLElementCallbackImpl

{.emit:["""
ComponentType.prototype.connectedCallback = HTMLElementCallback;
"""].}

proc init(event: Event) =
  echo "Test Page Init"
  customElements.define("my-component", ComponentType)
  let mc = document.createElement("my-component")
  document.body.appendChild(mc)
  echo "added test component to body"

window.onload = init

