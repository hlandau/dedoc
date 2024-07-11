local plain = require("classes.plain")

local class = pl.class(plain)
class._name = "ddbook"

SILE.scratch.ddbook = {
  seclevel = 0,
  seccount = {},
}

function class.push (t, val)
  if not SILE.scratch.ddbook[t] then
    SILE.scratch.ddbook[t] = {}
  end
  local q = SILE.scratch.ddbook[t]
  q[#q + 1] = val
end

function class.pop (t)
  local q = SILE.scratch.ddbook[t]
  q[#q] = nil
end

function class.val (t)
  local q = SILE.scratch.ddbook[t]
  return q[#q]
end

class.defaultFrameset.content.left = "8%pw"
class.defaultFrameset.content.right = "92%pw"

function class:_init (options)
  plain._init(self, options)

  self:loadPackage("image")
  self:loadPackage("simpletable", {
    tableTag = "tgroup",
    trTag = "row",
    tdTag = "entry",
  })
  self:loadPackage("rules")
  self:loadPackage("verbatim")
  self:loadPackage("footnotes")
  self:loadPackage("tableofcontents")
  self:loadPackage("counters")
  self:loadPackage("dlists")
  --self:loadPackage("twoside")

  class:declareFrame("lMargin", { left = "0", right = "8%pw", top = "0", bottom = "0" })

  -- Use a Helvetica font.
  SILE.settings:set("font.family", "TeX Gyre Heros", true)

  -- Use margins between paragraphs rather than first-line indentation to
  -- designate new paragraphs.
  SILE.settings:set("document.parindent", 0, true)
  SILE.settings:set("document.parskip", "4pt", true)
  SILE.settings:set("lists.parskip", "8pt", true)
end

function class.wipe (tbl)
  while #tbl > 0 do
    tbl[#tbl] = nil
  end
end

class.registerCommands = function (self)
  plain.registerCommands(self)

  self:registerCommand("doc", function (_, content)
    SILE.process(content)
  end)

  self:registerCommand("docctl", function (_, content)
  end)

  self:registerCommand("docbody", function (_, content)
    SILE.process(content)
  end)

  self:registerCommand("ddbook-secfont", function (_, content)
    SILE.call("font", { family = "TeX Gyre Heros", weight = 800 }, content)
  end)

  self:registerCommand("ddbook-bffont", function (_, content)
    SILE.call("font", { family = "TeX Gyre Heros", weight = 800 }, content)
  end)

  self:registerCommand("ddbook-ttfont", function (_, content)
    SILE.call("font", { family = "Courier New", size = "2ex" }, content)
  end)

  self:registerCommand("ddbook-sec-title", function (_, content)
    SILE.call("noindent")
    SILE.call("bigskip")
    SILE.call("ddbook-secfont", {}, { content })
    SILE.call("bigskip")
  end)

  local defineSecLevel = function (n, fontSize)
    self:registerCommand("ddbook-sec-" .. n .. "-title", function (_, content)
      SILE.call("font", { size = fontSize }, function ()
        if n == 1 then
          SILE.call("bigskip")
        end
        SILE.call("ddbook-sec-title", {}, content)
      end)
    end)
  end

  defineSecLevel(1, "20pt")
  defineSecLevel(2, "11pt")
  defineSecLevel(3, "11pt")
  defineSecLevel(4, "11pt")
  defineSecLevel(5, "11pt")
  defineSecLevel(6, "11pt")
  defineSecLevel(7, "11pt")

  self:registerCommand("sec", function (_, content)
    SILE.scratch.ddbook.seclevel = SILE.scratch.ddbook.seclevel + 1

    SILE.scratch.ddbook.seccount[SILE.scratch.ddbook.seclevel] = (SILE.scratch.ddbook.seccount[SILE.scratch.ddbook.seclevel] or 0) + 1

    while #SILE.scratch.ddbook.seccount > SILE.scratch.ddbook.seclevel do
      SILE.scratch.ddbook.seccount[#SILE.scratch.ddbook.seccount] = nil
    end
    
    local hdr = SILE.inputter:findInTree(content, "hdr")
    if hdr then
      local secno = SILE.inputter:findInTree(hdr, "secno")
      local title = SILE.inputter:findInTree(hdr, "title")
      if secno and title then
        SILE.call("ddbook-sec-" .. SILE.scratch.ddbook.seclevel .. "-title", {}, function ()
          local numFrame = SILE.getFrame("lMargin")
          local numTarget = numFrame:left()

          SILE.process(secno)
          SILE.typesetter:typeset(" ")
          SILE.process(title)
        end)
        self.wipe(title)
      end
    end

    SILE.process(content)

    SILE.scratch.ddbook.seclevel = SILE.scratch.ddbook.seclevel - 1
  end)

  self:registerCommand("hdr", function (_, content)
  end)

  self:registerCommand("secno", function (_, content)
    SILE.process(content)
  end)

  self:registerCommand("lint", function (_, content)
    SILE.process(content)
  end)

  self:registerCommand("title", function (_, content)
    SILE.process(content)
  end)

  self:registerCommand("p", function (_, content)
    SILE.process(content)
    SILE.call("par")
  end)

  self:registerCommand("dict", function (_, content)
    local items = {}
    for i = 1, #content do
      if type(content[i]) == "table" and content[i].command == "dice" then
        local dick = SILE.inputter:findInTree(content[i], "dick")
        local dicb = SILE.inputter:findInTree(content[i], "dicb")

        local n = { dicb }

        n.command = "item"
        n.options = dick
        table.insert(items, n)
      end
    end
    SILE.call("description", {}, items)
  end)

  self:registerCommand("dick", function (_, content)
    SILE.process(content)
  end)

  self:registerCommand("dicb", function (_, content)
    SILE.process(content)
  end)

  self:registerCommand("tt", function (_, content)
    SILE.call("ddbook-ttfont", {}, content)
  end)

  self:registerCommand("listing", function (_, content)
    SILE.call("verbatim", {}, content)
  end)

  self:registerCommand("ul", function (_, content)
    local items = {}
    for i = 1, #content do
      if type(content[i]) == "table" and content[i].command == "li" then
        content[i].command = "item"
        table.insert(items, content[i])
      end
    end
    SILE.call("itemize", {}, items)
  end)

  self:registerCommand("ol", function (_, content)
    local items = {}
    for i = 1, #content do
      if type(content[i]) == "table" and content[i].command == "li" then
        content[i].command = "item"
        table.insert(items, content[i])
      end
    end
    SILE.call("enumerate", {}, items)
  end)

  self:registerCommand("li", function (_, content)
    SILE.call("item")
    SILE.process(content)
  end)

  self:registerCommand("figure", function (_, content)
    SILE.process(content)
  end)

end

return class
