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

## Nimponents can extend WebComponent to add custom properties and functions
type WebComponent* = ref object of HTMLElement

proc setupNimponent*[T: WebComponent](
  elementName: string,
  constructor: proc(self: T): void = nil,
  connectedCallback: proc(self: T): void = nil,
  disconnectedCallback: proc(self: T): void = nil,
  adoptedCallback: proc(self: T): void = nil,
  attributeChangedCallback: proc(self: T, name, oldValue, newValue: string): void = nil
) = 
  ## Define a custom web element
  let newNimponentJS {.exportc.} = constructor
  let connectedCallbackJS {.exportc.} = connectedCallback
  let disconnectedCallbackJS {.exportc.} = disconnectedCallback
  let adoptedCallbackJS {.exportc.} = adoptedCallback
  let attributeChangedCallbackJS {.exportc.} = attributeChangedCallback

  # Nim does not have a way to define classes
  # but this is required to define a custom element
  {.emit:[""" let clazz = class extends HTMLElement {
  constructor() {
    super();
    if (newNimponentJS)
      newNimponentJS(this);
  }
  connectedCallback() {
    if (connectedCallbackJS)
      connectedCallbackJS(this);
  }
  disconnectedCallback() {
    if (disconnectedCallbackJS)
      disconnectedCallbackJS(this);
  }
  adoptedCallback() {
    if (adoptedCallbackJS)
      adoptedCallbackJS(this);
  }
  attributeChangedCallback(name, oldValue, newValue) {
    if (attributeChangedCallbackJS)
      attributeChangedCallbackJS(name, oldValue, newValue);
  }
};
"""].}
  var clazz {.exportc, nodecl.}: proc(): void
  customElements.define(elementName, clazz)



