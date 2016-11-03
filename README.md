# Horofree
Parking meter for freelancers

## Run the application
You need to install Elm on your computer, follow the instructions here: https://guide.elm-lang.org/get_started.html

You also need elm-css installed globally to compile the stylesheet

```bash
$ npm install -g elm-css
```

Then

```bash
$ npm install
```

Answer yes when prompt by `elm-package`

```bash
$ npm run dev
```

If you change anything in the file Stylesheets.elm you have to run the CSS script to build it:

```bash
$ npm run css
```

## Roadmap
- [x] Round income to 2 decimals
- [x] Use elm-css
- [x] Global settings
- [x] Add several stopwatches
- [x] Format income for different currency
- [ ] Use local storage
- [ ] Use router
- [ ] Organize the application in separate modules
- [ ] Checkpoints
- [ ] Give a name to a stopwatch
- [ ] Give a description to a stopwatch
