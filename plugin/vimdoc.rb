#!/usr/bin/env ruby

begin
  require 'colorize'
  $color = true
rescue LoadError
  $color = false
end

module Formatting
  WID  = 80
  SEP  = 2
  IWID = WID-2
  HWID = WID/2-2

  def box(text)
    (fill + b + red(text.center(IWID)) + b + n + fill)
  end

  def clearbox(text)
    (blank + b + white(text.center(IWID)) + b + n + blank)
  end

  def arrow(parts)
    ft = ->(s) { green(s[0...HWID].center(HWID)) }
    (b + ft["#{parts[1]} #{parts[3]}"] + a + ft[parts[4]] + b + n)
  end

  def fill;  (b * WID + n)              end
  def sep;   (n * SEP)                  end
  def blank; (b + (' ' * IWID) + b + n) end

  private

    def c(c, t)
      $color ? t.send(c) : t
    end

    def red(s);    c('red', s)   end
    def yell(s);   c('yellow', s) end
    def green(s);  c('green', s) end
    def blue(s);   c('blue', s)  end
    def white(s);  c('white', s) end

    def n; ?\n        end
    def s; ' '        end
    def a; yell('=>') end
    def b; blue(?#)   end
end

class VimDoc
  include Formatting

  VIMRC = "#{ENV['HOME']}/.vimrc"

  def initialize(path = VIMRC)
    vimrc = File.read(VIMRC)
    @lines = vimrc.lines.map { |l| VimLine.new(l) }
    @doc   = format filter @lines.reject(&:noise)
  end

  class VimLine
    include Formatting

    MKEYS = %w(cm cmap cno cnoremap im imap ino inoremap lm lmap ln lnoremap map! map nm
               nmap nn nnoremap no! noremap! no noremap om omap ono onoremap smap snor
               snoremap vm vmap vn vnoremap xm xmap xn xnoremap).join(?|)

    MARGS = %w(\<buffer\> \<nowait\> \<silent\> \<special\> \<script\> \<expr\> \<unique\>).join(?|)


    HEADING     = /^"\s*[A-Z].*$/      # a capital following a left aligned double quote
    DOC_COMMENT = /^\s*"".*$/          # two double quotes in a row
    BINDING     = /^\s*(#{MKEYS})\s+(#{MARGS})?\s*([^\s]+)\s+([^"\n]+).*/ # key mappings

    attr_reader :heading, :binding, :doc_comment

    def initialize(text)
      @text = text
      @heading, @binding, @doc_comment =
        [HEADING, BINDING, DOC_COMMENT].map { |rgx| rgx === text }
      @parts = text.match(BINDING) if @binding
    end

    def content
      (@binding || @doc_comment)
    end

    def noise
      !(@heading || @binding || @doc_comment)
    end

    def to_s
      @binding ? @text.strip : @text.delete('"').strip
    end

    def format
      case
      when @heading then box(to_s)
      when @binding then arrow(@parts)
      else clearbox(to_s)
      end
    end
  end

  def to_s; @doc end

private

  def filter(lines)
    if lines.empty? || lines.size == 1
      lines
    elsif lines[0].heading && lines[1].heading
      filter(lines[1..-1])
    else filter(lines[1..-1]).unshift(lines[0])
    end
  end

  def format(doc)
    doc.map.with_index do |line, i|
      if doc[i+1].nil?
        line.format + fill
      elsif !line.heading && doc[i+1].heading
        line.format + fill + sep
      else line.format
      end
    end
  end

end

$color = false if ARGV.any? {|a| a == '--no-color'}
puts VimDoc.new.to_s
