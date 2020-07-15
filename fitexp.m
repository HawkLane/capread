## Copyright (C) 2019 HLA
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} fitexp (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: HLA <HLA@LAPTOP-JPK4SPHQ>
## Created: 2019-10-06

function retval = fitexp (grounds, rises, power)
     g0=mean(grounds);
     r0=mean(rises);
     fittedrise=r0.*(grounds/g0).^(power);
     return fittedrise;
endfunction
