# Nimponents

- Nim library to define Web Components.

- [How to use WebComponents](https://developer.mozilla.org/en-US/docs/Web/API/Web_components)


## Example

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <script src="example.js"></script>
</head>
<body>
  <my-component/>
</body>
</html> 
```

```nim
import nimponents

# Define our custom web element
proc newMyComponent(e: WebComponent): Nimponent =
  result = Nimponent()
  result.self = e
  result.connectedCallback = proc() =
    e.innerHTML = "<p>Hello from MyComponent2</p>"

# register our custom web element
setupNimComponent("my-component", newMyComponent)
```