class HomeController < ApplicationController
  before_action :forbid_login_user, {only: [:top]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}

  @@lang = ''

  def top
  end

  def about
  end

  def quiz
    require 'net/http'
    require 'uri'
    require 'json'

    url = 'https://api.github.com/gists/public?page=' + rand(10).to_s + '&per_page=1'
    res = Net::HTTP.get(URI.parse(url))
    array = JSON.parse(res)

    lang = ""
    code = ""

    for element in array
        filename = element["files"].keys.first
        @@lang = element["files"][filename]["language"]
        if is_programming_lang?(@@lang) && @@lang != nil
          @langClass = "language-" + @@lang.downcase
          raw_url = element["files"][filename]["raw_url"]
          @code = Net::HTTP.get(URI.parse(raw_url)).to_s.force_encoding('UTF-8')
          break
        end
      end
    end

  def judge
    if params[:answer] == @@lang
      flash[:notice] = "正解です！"
      #ログインしていたらscoreをプラスする処理
    else
      flash[:notice] = "正解は#{@@lang}でした！"
    end
    redirect_to("/quiz")
  end

  private
  def is_programming_lang?(lang)
    # nonpro_lang = ['ABNF','API Blueprint','ASN.1','Adobe Font Metrics','Altium Designer','Ant Build System','ApacheConf','AsciiDoc','BibTeX','Blade','C-ObjDump','COLLADA','CSON','CSS','CSV','Cabal Config','Closure Templates','Cloud Firestore Security Rules','CoNLL-U','Cpp-ObjDump','Creole','D-ObjDump','DNS Zone','Darcs Patch','Diff','EBNF','EJS','EML','Eagle','Easybuild','Ecere Projects','EditorConfig','Edje Data Collection','FIGlet Font','Formatted','GN','Gerber Image','Gettext Catalog','Git Attributes','Git Config','Glyph Bitmap Distribution Format','Gradle','Graph Modeling Language','GraphQL','Graphviz (DOT)','HAProxy','HTML','HTML+Django','HTML+ECR','HTML+EEX','HTML+ERB','HTML+PHP','HTML+Razor','HTTP','HXML','Haml','Handlebars','INI','IRC log','Ignore List','JSON','JSON with Comments','JSON5','JSONLD','Java Properties','Jupyter Notebook','KiCad Layout','KiCad Legacy Layout','KiCad Schematic','Kit','LTspice Symbol','Latte','Less','Linker Script','Linux Kernel Module','Liquid','MTML','Markdown','Marko','Mask','Maven POM','MediaWiki','NL','Nginx','Ninja','ObjDump','OpenStep Property List','OpenType Feature File','Org','Pic','Pickle','Pod','Pod 6','PostCSS','PostScript','Protocol Buffer','Public Key','Pug','Pure Data','Python traceback','RAML','RDoc','RHTML','RMarkdown','RPM Spec','RUNOFF','Raw token data','Regular Expression','Rich Text Format','Roff','Roff Manpage','SCSS','SPARQL','SQL','SRecode Template','SSH Config','STON','SVG','Sass','Scaml','Slim','Spline Font Database','Stylus','SubRip Text','SugarSS','Svelte','TOML','TeX','Tea','Texinfo','Text','Textile','Turtle','Twig','Type Language','Unity3D Asset','Vue','Wavefront Material','Wavefront Object','Web Ontology Language','WebVTT','Windows Registry Entries','World of Warcraft Addon Data','X BitMap','X Font Directory Index','X PixMap','XCompose','XML','XML Property List','XPages','YAML','YANG','YASnippet','desktop','edn','nanorc','reStructuredText']
    nonpro_lang = ['SVG', 'YAML', 'HTML', 'XML', 'JSON', 'Git']
    for item in nonpro_lang
        if item == lang
            return false
        end
    end
    return true
  end
end
