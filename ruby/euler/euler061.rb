def tri(n) n * (n + 1) / 2 end
def square(n) n ** 2 end 
def pent(n) n * (3 * n - 1) / 2 end 
def hex(n) n * (2 * n - 1) end 
def sept(n) n * (5 * n - 3) / 2 end 
def oct(n) n * (3 * n - 2) end 
# 4-digits range (inclusive)
# tri 45-140
# square 32-99
# pent 26-81
# hex 23-70
# sept 21-63
# oct 19-58
#
# TODO: create list/hash of tri-tuples with 1st 2 digits and last 
# 2 digits of each number in tri, square, pent, etc.
# Once hash is built (<500 entries), walk through it matching
# last 2 with 1st 2, building chains. Find a 6-chain that has one
# each of the polynomial classes.
