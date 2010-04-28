#!/usr/bin/ruby
require 'rubygems'
require 'RMagick'
require 'benchmark'
require 'base64'


puts Magick::Long_version

# Our test image (BBG Logo)
image = "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\n" +
  "udYb09QVxW8LlTIFZYEFdXPJiIESBEw2+DTQ6AfFKDObgnETFmZitpno2D5s\n" +
  "i7q/ZnPzf7bEOTOnspH6aQxBoolOtjkHjrg/QFugQGj501oM0NIW+u7Oue++\n" +
  "9r4nla18tMlp2vvue/eee84953d+9z3USFD/0ENgS5fNlbwwOXXm1dERY2Li\n" +
  "gCkz64lBp5P81tJCMjKeYlwRI4pgX+fn5KYB1EU3lvJXriQfHzxI0tPTly9Z\n" +
  "usSK+QH3sqXTYlv1bNFKdLlas3lH0aqibxVY+9P1G1euNDXVf3jwo+MPmizi\n" +
  "g80bNy2z767pH/dOxki/6EjA3u4hh7Y9qeegQsLUNJNgEIQq7fFOmwXDr756\n" +
  "714ZISrXGXkSyOKxAKEz2bB+PblUX69nqZH3gyBnhMtpDFAFAzpxDKj4kuGZ\n" +
  "SdHmEBlrmgwNOk3TUxSCrBSzQNrEuT4Whr7K1kdl7416yPwFC5B4U4p9Mj4+\n" +
  "YSjZsGFrY0NDLcZIpT+Vc0/c/dBafqbSjyNffYQEVuF5vRyABaI2GCDaeMQD\n" +
  "dDx7WBS0+V8sD/fipOPiec3NhPsW2byp9NWenh6nvb/vYnx8vEFhqMGN18IE\n" +
  "zKia0p9KoaiVhfxcKtc6AjKkwv14jXkIjbShZ33z9ZnLhw9/fgF+h2/EOYAX\n" +
  "3l00FUKIGLvy0wLgkS1EwwUMwEwfFj1Wi7XOlG16XsHvgPkRpRh0JNKfRMsW\n" +
  "YYXu7yeOF/ETdVtCojE06Zu8DT815x9kDHAxYRKb9qiMCHcjk6SMi6Q+KDWH\n" +
  "CgoLNmHpiZZwu12k7oe6GwyWS5KqfzQ0KSqv7kbV97Hf6jYIbhhRnZWVlWNs\n" +
  "++Gqz5tHTp44IVs9Vssz5aWI8mKZiYr+/OsvtQBBzcjuo6s5BgZIxY6K9+Hy\n" +
  "CFwPiXV81FKXcQiSsk+JJJQ6WPqK40k8Nog1Q9UrVaWv79496odsEl4UvW4M\n" +
  "lE8ByEeYxOz2ouWpetVhX4Xzv8s1Qt7bf+CD7q4uPI2wFBcXM+pzNstr3V7r\n" +
  "5uJ/ypZG3QbYXociMj0Oh0NGi2j1qTlYflrE+OjqgiglKE7l0dRU8uXpr/YP\n" +
  "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\n" +
  "Ow24zGaTCfBSPVgjURJooSf4pIeaL7VrUqLeaFMA40W5DUedgZJK6TLGuP/Z\n" +
  "p5/949q1q2hKndhUdfSrL3c+9fTTz3ncnsCNhHvcPPac+7BKnQCb2Hq/rc3I\n" +
  "URI4t5JU8umnBvXYLypVLRpIa4Cka2baaAgNcomFEnXFgepchzmbGzduVq1b\n" +
  "u3YXc09uFsPoWSt0X/bU8Ei3hPd8vc780ICP+DEgDci6cyzhBAyFwMnQweBL\n" +
  "XVpamifRauWlpBgJtBTYgltdffn+8WNfn8ZyDPucBs+tYj/pDu8Vk68Y5gBa\n" +
  "gz4LKa1o0KDcp5YYUec6zDuBIvhgPS1Ax48qqNYptDKYLR1yBcJHeoH78tp8\n" +
  "Pn3mS0k1ub0yRGoAoJt/PWJExqhRo8SFeXnLfpWVNd/R5ohxs2YcudtRbsI5\n" +
  "c+Y7W+G6ws31dXU3GUbmLRYLFX1BcysmXNJUsRvMJ8xCiUGar1RC9e7TWJ9y\n" +
  "n1SaUqWpda7DAHXgwIy4SZMnD8/MzEwYPXq04+WcHB8mLIPcBGcxmwW47sKX\n" +
  "R4+6/NWX3mC+ovlBaXCTmgma1RkqB2QpKSlxG4s2vUNYj15Lq90vU9h6duPG\n" +
  "DdfJim/OfvrJJ/ttNtstlhS5g/4eBcNoxnK7GGremeWg3TX7hPpT5sFWSuxE\n" +
  "87WqT37rprEXwROEhYeT0dnZ2Tj8pb6WZk3r1NzU7Lx7t/EP8PYY4b3GnpXf\n" +
  "fgrNF/U0X5Z2TYlXS0+I+SUkPjaOJo8caXkeNmRJfv6AkydOIN7f+v2ZM6j5\n" +
  "ZOq0aSQmJkYKBLU1X+wW82V/rK35IlvDo2g+VfVKy902om7A2RXMQzogNjYB\n" +
  "dB6ICW3q5U2E70Hh+adgvqDHfKqt+Qp2rquroxC0edDs4bcx0TGm+IR4U58+\n" +
  "fYjBSDgBEAGBYbaE9x8/eVLBlJemFsDNtQVLl8448Pn+s9OnT+fkhLeG5kuj\n" +
  "O3r/P1o1NZ9qe/2uNN/fP0K069O4FwDbpJ7UroIUeZ+owWBkiEpgjTZYQ+Z6\n" +
  "i/md+nythhr5BYxvemvlyvW3bt66w4p3KMLmxflLZhasXJmvhnx4PyY4gNn9\n" +
  "NxYVnWyyNeEZS1POKzNCSr8qaNYN5tNOoJ6o7/N1IFwI1OsEEiLzD5SWlm8u\n" +
  "Kt7L9sDXCfFKDl8k2A+BjPf2JvM79fmidOBA3ZSgmDCD1LsvdXKhP29kRQ7j\n" +
  "rh07KxMSExv/9MbSDU7n/cCflDcv4sVpUxec/+Hcd0rjQvCminquBrMtYWFk\n" +
  "wsSJ5Mjhw4GMYr1DwTkJuSDqAxkItSWYaBCDjtio10j9XKFE7zrK/D78b4f/\n" +
  "Efnc6yLalyrSHDXwRBB6mfmdar5+4gSL3AxDCaxixScnJ5PU1FRuzty5WS5X\n" +
  "R6imSLDPTXi3Jwa+i1J8tJbmixoWZ1NxEVmcny+lfyMjI0nhunVkx7btBNxI\n" +
  "22vz5vGSaQ2aywQW6BeDBlkHZWamNDc3n1fwN7qnqL5R6XoajY8fsNnuSrBN\n" +
  "bkTVsRAy/lf2AZXBCbT5kpKSNIUFjxU01NfLuQeljaA3mM8xnK9aU0DAJzMh\n" +
  "MCJX6IyNizUh1EtISGj3+oSkvLxF0bPnzpnd2to6GxZo9gTl7KUzHiDpeL6j\n" +
  "srLqUnR0lI9q+GlsgAu3hOOjGNLf27ZtflKStQ1g5YPBQ4b40HU4HA7pOifM\n" +
  "89bbb3NFmzdzn5eWltnt9pOJVuusYL+M84ElivjblndXv7m8oLa6urqhYOUK\n" +
  "8vriJa/zXr4QH4gQbC2wQ8AOELWmpuY/KAdEMiDa0b6lj4VkjxkzZMfu3blI\n" +
  "a3x8fEfm4MEiuoPQwM8AxtJ8Z+3qVbsOtDpELpy1UfzfaT5VRcM0sM0K701O\n" +
  "SYlfu37dO/KFspuoq6/TDXZ8Puwlv0s+3PvB/uPHjh2Zn5ubrXQia2kUWJEM\n" +
  "GAuV98ppqOBXdU01OXXqFP/xvn0lO3fvngjLiQmOGfBRJTGxMRkffrzvCGbk\n" +
  "sEiJz/WgIbkEmQsOgKrlZWUnyw+WVWDGDubjAzq3g15p/dOG4lDeY1urZmEH\n" +
  "tP7qlSs131ZVVYUNH97Hq6R3e4v5ehk+GhDw6YRLGl+oT1Hh966ODjCfNjxE\n" +
  "fK1k1+6dDQ0N2P1hi46KapZrC4/ePyD/juSfn/j6q2PlM3Nm/P7dre/tsVqt\n" +
  "gziWgFHTKD0CRePAtUIvVvJu375NPtq79++HD5XvJ/5DVJxbfx+6lY4gHpfb\n" +
  "0t7uTCeCJ0LC2b2p+XoZPtgQDNfNeBoUG6fkQ2qd5CvBQvBeD/hKL5p2vrGh\n" +
  "wX750qWayhOVldevX70Cv+VkwVA9BolDhw37jcvtIuCHGTncIzIfO1elMxPc\n" +
  "xQsXrk4Y+8Jz4CKemTPvtRXPjhgxHoTMEgZuJMwcFvCMG+y1RNOMDHe03qOX\n" +
  "Ll28WV526OAPZ8/i81HaGJ1oylxwH4fXAkqRK3SPyC2s6gEKCjMYjQYXbzB6\n" +
  "2iHw72iVcyaPnf9Gdhid4xQzyak6dY0wwuE9thKlstLqQ4iTBGeUBg1Us3a2\n" +
  "mW0M5vDsOxQurKNnELkFyUQevVECiylNjFkoZCgM0URur4qHdSQAA6OAxHDW\n" +
  "58XJuSTRC+tzMaiq0Gpn4z77jDLa4hit8T2k1cfmtrH3SWwfeuMwoMjWjHDd\n" +
  "pmY+xwgyM0YZHs6w+YdPNaiOsBhV83M9XISgwtl+ZVP9hjIMKkGlKiFVhha9\n" +
  "HGO4+v4eGH//vnCqve0F9ffTIu3dfwEp65FyXTsCMgAAAABJRU5ErkJggg==\n"

image = Base64.decode64(image)

# Simulate multiple parallel requests by forking and executing test
8.times do
  Process.fork do
    Benchmark.bm(8) do |x|
      x.report{
        if ENV['DISPLAY']
          # If we have an X display test by displaying the image
          img = Magick::Image.from_blob(image).first
          gc = Magick::Draw.new
          gc.annotate(img, 200, 10, 5, 40, "Pid: #{$$} Running interactively") do
            self.pointsize = 12
            self.font_weight = Magick::NormalWeight
            self.font_style = Magick::NormalStyle
            self.decorate = Magick::NoDecoration
          end

          img.compress_colormap!
          img.display
        else
          # Otherwise to compute the image 10 times and toss the results
          1000.times do |i|
            img = Magick::Image.from_blob(image).first
            gc = Magick::Draw.new
            gc.annotate(img, 200, 10, 5, 40, "Pid: #{$$} Loop: #{i}") do
              self.pointsize = 12
              self.font_weight = Magick::NormalWeight
              self.font_style = Magick::NormalStyle
              self.decorate = Magick::NoDecoration
            end

            img.compress_colormap!
            blob = img.to_blob{self.quality = 100}
          end
        end
      }
    end
  end
end
