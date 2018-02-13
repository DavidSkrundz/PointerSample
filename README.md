# PointerSample

Example of using `UnsafeMutableRawPointer` to send/receive pointers from C functions.

## Expected output

```
Init P: PARENT
Init C: CHILD
End: Parent Changed
End: ["Child Changed"]
End: Child Changed
Deinit P: Parent Changed
Deinit C: Child Changed
```
