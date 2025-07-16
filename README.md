# Ryan's Neovim configuration

## nixCats

My configuration is based of the nixCats 'simple' template found [here](https://github.com/BirdeeHub/nixCats-nvim/tree/main/templates/simple)

## Structure
A lua file found in <em>./plugins/</em> represents the configuration for a nixCats category. While each nixCats category represents a collection of dependencies used in that configuration. Each lua file should share the same name as its corresponding category. Best practice is for your lua configurations to always use the dependecy and never use a dependecy(maybe it's okay for the config to check and consume another nixCat?).


