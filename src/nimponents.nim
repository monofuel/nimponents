# Nimponents
# Web Components for Nim
import std/[dom, jsffi, strformat, strutils]


# Webcomponents stuff
type
  HTMLElement* {.importc.} = ref object of Element
  CustomElements* = ref object of RootObj
    define*: proc (name: cstring, elem: proc(): auto)
var customElements* {.importc: "customElements" .}: CustomElements
proc eval*(s: cstring) {.importc: "eval", nodecl.}

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

proc setupNimComponent*(
  elementName: string,
  newNimponent: proc(e: WebComponent): Nimponent) = 
  ## Define a custom web element
  let newNimponentJS {.exportc.} = newNimponent
  # automatically convert the element name to a class name
  # my-component -> MyComponent
  var parts = elementName.split('-')
  for i in 0..<parts.len:
    parts[i][0] = parts[i][0].toUpperAscii()
  let className = parts.join("")

  let createClassJS {.exportc.} = &"window.{className} = class {className} " &
  """extends HTMLElement {
  constructor() {
    super();
    const n = newNimponentJS(this);
    this.nimponent = n;
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
""" & &"customElements.define('{elementName}', window.{className});"

  # I'm sorry for many things that I've done
  # but this eval is not one of them
  eval(createClassJS.cstring)
