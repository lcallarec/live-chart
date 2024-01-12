# Contributing

When contributing to this repository, it's always better to discuss the change you wish to make via an issue with the owner of this repository, but that's not always necessary.

## Code quality

We believe that a good software, from the end user perspective, is also a well designed software.

### Testing

Good tests are harder to write than good code. But they are at the core of good software design, especially when they are written _before_ the implementation. That TDD aproach is our favorite way of testing (and building) our library. If you're not familiar with TDD, Livechart owner can give you some guidance, don't be afraid :) If you're definitively not comfortable with TDD, don't worry, it's not blocking to contribute to the code.

But it is **mandatory** to all code contributors to write tests when they modify something. Be aware that we are testing business logic as well as rendering logic : you'll find all you need to be able to analyze what the user will see on the screen (yes, that kind of tests are a bit hard to write hence for this ones, TDD approach is not always preferred).

Tests can be run locally with `meson test -C build` or `./build/tests/livechart-test` for more detailed output.

### Public API

The public API is what the end developer will see of our library. The API must not only be written for _working_ but needs to be simple to use, and over all, pleasant to use. Hence, abstraction that hides complexity has huge importance.

If you're not sure about your API stability, just add the `[Version (experimental = true, experimental_until = "")]` annotation, so every developers using that API will be notified that this API could change in the future.

### Documntation

Update the documentation in README.md with details of changes on the public API, if it applies. Please provide screenshots or animated gifs if your changes impact something visible on the screen. We believe that good documentation allow our library to be used by more developers around the world.

## Pull Request Process

1. Ensure any install or build dependencies are removed before the end of the layer when doing a
   build.
2. Update the documentation in README.md with details of changes on the public API, if it applies. Please provide screenshots or animated gifs if your changes impact something visible on the screen. We believe that good documentation allow our library to be used by more developers around the world.
3.
