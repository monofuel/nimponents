# Nimponents
# Web Components for Nim
import std/[dom, jsffi, strformat, strutils]


# Webcomponents stuff
type
  HTMLElement* {.importc.} = ref object of Element
  CustomElements* = ref object of RootObj
    define*: proc (name: cstring, elem: proc(): void)
var customElements* {.importc: "customElements" .}: CustomElements

# Nimponents
type
  WebComponent* = ref object of HTMLElement
    nimponent*: Nimponent
  Nimponent* = ref object
    self*: WebComponent
    connectedCallback*: proc()
    disconnectedCallback*: proc()
    adoptedCallback*: proc()
    attributeChangedCallback*: proc(name, oldValue, newValue: string)

proc setupNimComponent*[T: WebComponent](
  elementName: string,
  newNimponent: proc(e: T): Nimponent) = 
  ## Define a custom web element
  let newNimponentJS {.exportc.} = newNimponent

  # TODO should define each callback separately with named parameters

  {.emit:[""" let clazz = class extends HTMLElement {
  constructor() {
    super();
    this.nimponent = newNimponentJS(this);
  }
  connectedCallback() {
    if (this.nimponent.connectedCallback)
      this.nimponent.connectedCallback();
  }
  disconnectedCallback() {
    if (this.nimponent.disconnectedCallback)
      this.nimponent.disconnectedCallback();
  }
  adoptedCallback() {
    if (this.nimponent.adoptedCallback)
      this.nimponent.adoptedCallback();
  }
  attributeChangedCallback(name, oldValue, newValue) {
    if (this.nimponent.attributeChangedCallback)
      this.nimponent.attributeChangedCallback(name, oldValue, newValue);
  }
};
"""].}
  var clazz {.exportc, nodecl.}: proc(): void
  customElements.define(elementName, clazz)



