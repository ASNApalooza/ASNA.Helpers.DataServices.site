class App
    def initialize(arguments,stdin)
        @arguments = arguments
        @stdin = stdin
        @indentLevel = 0
        @INDENT_SIZE = 4
        @outFile = File.open("index.html", "w")    
        @leadingSpaces = ""
    end

    def run
        @f1 = File.open(@arguments[0], "r")
        readFile(@f1)
        @f1.close
        @outFile.close
        puts ""
        puts "Done: all files expanded to index.html."
    end 

    def readFile(f)
        f.each_line do |line|
            copyLine = line.lstrip
            if ( copyLine.start_with?('//copy')) 
                next
            end

            if ( copyLine.start_with?('/copy')) 
                leftMargin = line.index('/copy') - @INDENT_SIZE                
                @leadingSpaces = (leftMargin > @INDENT_SIZE) ? " " * leftMargin : "" 
                @indentLevel += 1
                copyFile = copyLine[6..-1].strip
                @outFile.write "<!-- Begin: #{copyFile} -->\n"
                puts "Including: " + copyFile
                f2 = File.open(copyFile, "r")
                self.readFile(f2)
                f2.close         
                @indentLevel -= 1
                @leadingSpaces = ""       
                @outFile.write "<!-- End: #{copyFile} -->\n"
            else 
                #@outFile.write (@leadingSpaces + " " * (@indentLevel * @INDENT_SIZE)) + line
                @outFile.write line
            end
        end
    end
end 

app = App.new(ARGV,STDIN)
app.run