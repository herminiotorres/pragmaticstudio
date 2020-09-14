defmodule Servy.BearView do
  require EEx

  @template_path Path.expand("../../templates", __DIR__)

  EEx.function_from_file(:def, :index, Path.join(@template_path, "index.eex"), [:bears])

  EEx.function_from_file(:def, :show, Path.join(@template_path, "show.eex"), [:bear])
end
