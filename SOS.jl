#Use this Julia module to generate barrier certificates.
using MathOptInterface
const MOI = MathOptInterface
using JuMP
using SumOfSquares
using PolyJuMP
using Base.Test
using MultivariatePolynomials
using SemialgebraicSets
using Mosek

import DynamicPolynomials.@polyvar

@polyvar x[1:15]
f = [-1.548546352724634*x[1]+-2.357154303962378*x[2]+-5.815071753763429*x[3]+1.7953191330495875*x[4]+4.076774205647443*x[5]+0.7755329752897628*x[6]+-1.1877927499253578*x[7]+-0.6184552197259104*x[8]+-1.6595382177324114*x[9]+4.147429366538116*x[10]+0.3668659814738049*x[11]+-0.060483558178587735*x[12]+-0.7543048442540582*x[13]+3.393499451990565*x[14]+1.594175130168944*x[15],0.0*x[1]+0.0*x[2]+1.0*x[3]+0.0*x[4]+0.0*x[5]+0.0*x[6]+0.0*x[7]+0.0*x[8]+0.0*x[9]+0.0*x[10]+0.0*x[11]+0.0*x[12]+0.0*x[13]+0.0*x[14]+0.0*x[15],3.1519685226285534*x[1]+-2.6348969175583914*x[2]+-7.113228428414966*x[3]+1.180669708519076*x[4]+6.931134777140352*x[5]+0.8663699580696483*x[6]+2.6118793992253604*x[7]+0.6802468854807752*x[8]+-1.6320891098662598*x[9]+4.080694551396657*x[10]+2.103058272479264*x[11]+0.1072185285967212*x[12]+1.1441094794158615*x[13]+2.7466840927642893*x[14]+2.2504006440586988*x[15],0.0*x[1]+0.0*x[2]+0.0*x[3]+0.0*x[4]+1.0*x[5]+0.0*x[6]+0.0*x[7]+0.0*x[8]+0.0*x[9]+0.0*x[10]+0.0*x[11]+0.0*x[12]+0.0*x[13]+0.0*x[14]+0.0*x[15],-5.93589008699051*x[1]+-2.9196710986470356*x[2]+-3.656719262168224*x[3]+-2.4724985506338184*x[4]+-5.6637148279673895*x[5]+1.5215952291102084*x[6]+-2.2651098911863428*x[7]+-1.6066051893710303*x[8]+0.7110599833813186*x[9]+-0.07890130422535852*x[10]+-3.1759299328642516*x[11]+2.6928198694179315*x[12]+-2.525419043226729*x[13]+2.5227046100659622*x[14]+-1.323035103894001*x[15],0.0*x[1]+0.0*x[2]+0.0*x[3]+0.0*x[4]+0.0*x[5]+0.0*x[6]+1.0*x[7]+0.0*x[8]+0.0*x[9]+0.0*x[10]+0.0*x[11]+0.0*x[12]+0.0*x[13]+0.0*x[14]+0.0*x[15],2.269797264250643*x[1]+3.3751816682908355*x[2]+4.4420956699262435*x[3]+3.1926967748398134*x[4]+1.6487163708569357*x[5]+-4.607927260164063*x[6]+-3.731196519963354*x[7]+1.9158524155276508*x[8]+0.753752446108976*x[9]+-0.3524177318571078*x[10]+3.6830070720785635*x[11]+-3.6433341134268575*x[12]+0.03307639331558998*x[13]+-2.305513275311999*x[14]+0.31755710677400006*x[15],0.0*x[1]+0.0*x[2]+0.0*x[3]+0.0*x[4]+0.0*x[5]+0.0*x[6]+0.0*x[7]+0.0*x[8]+1.0*x[9]+0.0*x[10]+0.0*x[11]+0.0*x[12]+0.0*x[13]+0.0*x[14]+0.0*x[15],-0.7337347439086874*x[1]+0.8355784528776233*x[2]+1.358128432951854*x[3]+-2.9614035651865924*x[4]+-0.4515172869836104*x[5]+3.1940141418549572*x[6]+3.1560954837123867*x[7]+-5.5667048429916*x[8]+-3.6362696392723315*x[9]+3.3102291157975783*x[10]+-2.021186726164213*x[11]+2.176428044242506*x[12]+4.360954981198082*x[13]+-0.15606382068809704*x[14]+0.8584331327897154*x[15],0.0*x[1]+0.0*x[2]+0.0*x[3]+0.0*x[4]+0.0*x[5]+0.0*x[6]+0.0*x[7]+0.0*x[8]+0.0*x[9]+0.0*x[10]+1.0*x[11]+0.0*x[12]+0.0*x[13]+0.0*x[14]+0.0*x[15],-0.7299046358172397*x[1]+-2.662458998316692*x[2]+-2.135058943942405*x[3]+1.3229240055567721*x[4]+1.279531673649941*x[5]+-1.0152171458254948*x[6]+-1.9633245606274352*x[7]+3.6855544053264193*x[8]+0.35034747704893743*x[9]+-4.817347253204286*x[10]+-3.3072433031618713*x[11]+-0.29582862529481124*x[12]+-2.394290068934123*x[13]+-1.7185157609708073*x[14]+-2.03676165880647*x[15],0.0*x[1]+0.0*x[2]+0.0*x[3]+0.0*x[4]+0.0*x[5]+0.0*x[6]+0.0*x[7]+0.0*x[8]+0.0*x[9]+0.0*x[10]+0.0*x[11]+0.0*x[12]+1.0*x[13]+0.0*x[14]+0.0*x[15],4.870317194109085*x[1]+1.5463677645404472*x[2]+0.8452886379481945*x[3]+1.3340313737269298*x[4]+-0.6562419157348112*x[5]+0.8132458483014668*x[6]+0.8136455619313883*x[7]+1.3801174148851225*x[8]+-1.4305906498296332*x[9]+-0.4015753125328754*x[10]+0.8378045154194953*x[11]+-4.336249138777637*x[12]+-4.384723508090271*x[13]+2.7099535063051445*x[14]+2.879350891091322*x[15],0.0*x[1]+0.0*x[2]+0.0*x[3]+0.0*x[4]+0.0*x[5]+0.0*x[6]+0.0*x[7]+0.0*x[8]+0.0*x[9]+0.0*x[10]+0.0*x[11]+0.0*x[12]+0.0*x[13]+0.0*x[14]+1.0*x[15],-5.868979525867747*x[1]+-0.8960440931189642*x[2]+-2.7181906516081478*x[3]+-1.5363273058443485*x[4]+0.8315450601706282*x[5]+0.6562001087025472*x[6]+-1.0867984938782644*x[7]+-0.673585046531207*x[8]+1.3805986669753516*x[9]+3.248755206442924*x[10]+1.0419647711575852*x[11]+4.136589619363765*x[12]+3.120942670577048*x[13]+-5.702022376419041*x[14]+-4.335368474476038*x[15]]
init1 = (x[1] - -0.10000000000000142)*(0.10000000000000142-x[1])
init2 = (x[2] - -0.09999999999999998)*(0.10000000000000009-x[2])
init3 = (x[3] - -0.1)*(0.1-x[3])
init4 = (x[4] - -0.09999999999999998)*(0.10000000000000009-x[4])
init5 = (x[5] - -0.1)*(0.1-x[5])
init6 = (x[6] - -0.09999999999999998)*(0.10000000000000009-x[6])
init7 = (x[7] - -0.1)*(0.1-x[7])
init8 = (x[8] - -0.09999999999999998)*(0.10000000000000009-x[8])
init9 = (x[9] - -0.1)*(0.1-x[9])
init10 = (x[10] - -0.09999999999999998)*(0.10000000000000009-x[10])
init11 = (x[11] - -0.1)*(0.1-x[11])
init12 = (x[12] - -0.09999999999999998)*(0.10000000000000009-x[12])
init13 = (x[13] - -0.1)*(0.1-x[13])
init14 = (x[14] - -0.09999999999999998)*(0.10000000000000009-x[14])
init15 = (x[15] - -0.1)*(0.1-x[15])
init16 = (x[1] - (-0.10000000000000142))*((0.21796117045626562)-x[1])
init17 = (x[2] - (-0.09999999999999998))*((0.16758594213647188)-x[2])
init18 = (x[3] - (-0.1593232199756378))*((0.09999999999999999)-x[3])
init19 = (x[4] - (-0.286039913608602))*((0.10000000000000009)-x[4])
init20 = (x[5] - (-0.18016935273000576))*((0.1)-x[5])
init21 = (x[6] - (-0.09999999999999998))*((0.10325386984182588)-x[6])
init22 = (x[7] - (-0.1))*((0.23620715850445886)-x[7])
init23 = (x[8] - (-0.27092831049631316))*((0.10000000000000007)-x[8])
init24 = (x[9] - (-0.1))*((0.153828491110115)-x[9])
init25 = (x[10] - (-0.1862387157954507))*((0.10000000000000007)-x[10])
init26 = (x[11] - (-0.1))*((0.29671671725149285)-x[11])
init27 = (x[12] - (-0.09999999999999998))*((0.2370167845045249)-x[12])
init28 = (x[13] - (-0.1))*((0.14119866393294409)-x[13])
init29 = (x[14] - (-0.19220561859876129))*((0.10000000000000009)-x[14])
init30 = (x[15] - (-0.1))*((0.20688876909620255)-x[15])
unsafe1 = (x[1] - 0.0)^2 - 4.0
unsafe2 = (x[2] - -0.2)^2 - 0.48999999999999994
unsafe3 = (x[3] - 0.0)^2 - 1.0
unsafe4 = (x[4] - 0.0)^2 - 0.25
unsafe5 = (x[5] - 0.0)^2 - 1.0
unsafe6 = (x[6] - 0.0)^2 - 0.25
unsafe7 = (x[7] - 0.0)^2 - 1.0
unsafe8 = (x[8] - 0.0)^2 - 0.25
unsafe9 = (x[9] - 0.0)^2 - 1.0
unsafe10 = (x[10] - 0.0)^2 - 0.25
unsafe11 = (x[11] - 0.0)^2 - 1.0
unsafe12 = (x[12] - 0.0)^2 - 0.25
unsafe13 = (x[13] - 0.0)^2 - 1.0
unsafe14 = (x[14] - 0.0)^2 - 0.25
unsafe15 = (x[15] - 0.0)^2 - 1.0

m = SOSModel(solver = MosekSolver())

Z = monomials(x, 0:1)
@variable m Zinit1 SOSPoly(Z)
@variable m Zinit2 SOSPoly(Z)
@variable m Zinit3 SOSPoly(Z)
@variable m Zinit4 SOSPoly(Z)
@variable m Zinit5 SOSPoly(Z)
@variable m Zinit6 SOSPoly(Z)
@variable m Zinit7 SOSPoly(Z)
@variable m Zinit8 SOSPoly(Z)
@variable m Zinit9 SOSPoly(Z)
@variable m Zinit10 SOSPoly(Z)
@variable m Zinit11 SOSPoly(Z)
@variable m Zinit12 SOSPoly(Z)
@variable m Zinit13 SOSPoly(Z)
@variable m Zinit14 SOSPoly(Z)
@variable m Zinit15 SOSPoly(Z)
@variable m Zinit16 SOSPoly(Z)
@variable m Zinit17 SOSPoly(Z)
@variable m Zinit18 SOSPoly(Z)
@variable m Zinit19 SOSPoly(Z)
@variable m Zinit20 SOSPoly(Z)
@variable m Zinit21 SOSPoly(Z)
@variable m Zinit22 SOSPoly(Z)
@variable m Zinit23 SOSPoly(Z)
@variable m Zinit24 SOSPoly(Z)
@variable m Zinit25 SOSPoly(Z)
@variable m Zinit26 SOSPoly(Z)
@variable m Zinit27 SOSPoly(Z)
@variable m Zinit28 SOSPoly(Z)
@variable m Zinit29 SOSPoly(Z)
@variable m Zinit30 SOSPoly(Z)
Z = monomials(x, 0:1)
@variable m Zunsafe1 SOSPoly(Z)
@variable m Zunsafe2 SOSPoly(Z)
@variable m Zunsafe3 SOSPoly(Z)
@variable m Zunsafe4 SOSPoly(Z)
@variable m Zunsafe5 SOSPoly(Z)
@variable m Zunsafe6 SOSPoly(Z)
@variable m Zunsafe7 SOSPoly(Z)
@variable m Zunsafe8 SOSPoly(Z)
@variable m Zunsafe9 SOSPoly(Z)
@variable m Zunsafe10 SOSPoly(Z)
@variable m Zunsafe11 SOSPoly(Z)
@variable m Zunsafe12 SOSPoly(Z)
@variable m Zunsafe13 SOSPoly(Z)
@variable m Zunsafe14 SOSPoly(Z)
@variable m Zunsafe15 SOSPoly(Z)
Z = monomials(x, 0:4)
@variable m B Poly(Z)

x1 = x[1] + 0.01*f[1]
x2 = x[2] + 0.01*f[2]
x3 = x[3] + 0.01*f[3]
x4 = x[4] + 0.01*f[4]
x5 = x[5] + 0.01*f[5]
x6 = x[6] + 0.01*f[6]
x7 = x[7] + 0.01*f[7]
x8 = x[8] + 0.01*f[8]
x9 = x[9] + 0.01*f[9]
x10 = x[10] + 0.01*f[10]
x11 = x[11] + 0.01*f[11]
x12 = x[12] + 0.01*f[12]
x13 = x[13] + 0.01*f[13]
x14 = x[14] + 0.01*f[14]
x15 = x[15] + 0.01*f[15]

B1 = subs(B, x[1]=>x1, x[2]=>x2, x[3]=>x3, x[4]=>x4, x[5]=>x5, x[6]=>x6, x[7]=>x7, x[8]=>x8, x[9]=>x9, x[10]=>x10, x[11]=>x11, x[12]=>x12, x[13]=>x13, x[14]=>x14, x[15]=>x15)

f1 = -B - Zinit1*init1 - Zinit2*init2 - Zinit3*init3 - Zinit4*init4 - Zinit5*init5 - Zinit6*init6 - Zinit7*init7 - Zinit8*init8 - Zinit9*init9 - Zinit10*init10 - Zinit11*init11 - Zinit12*init12 - Zinit13*init13 - Zinit14*init14 - Zinit15*init15 - Zinit16*init16 - Zinit17*init17 - Zinit18*init18 - Zinit19*init19 - Zinit20*init20 - Zinit21*init21 - Zinit22*init22 - Zinit23*init23 - Zinit24*init24 - Zinit25*init25 - Zinit26*init26 - Zinit27*init27 - Zinit28*init28 - Zinit29*init29 - Zinit30*init30
f2 = B - B1
f3 = B - Zunsafe1*unsafe1
f4 = B - Zunsafe2*unsafe2
f5 = B - Zunsafe3*unsafe3
f6 = B - Zunsafe4*unsafe4
f7 = B - Zunsafe5*unsafe5
f8 = B - Zunsafe6*unsafe6
f9 = B - Zunsafe7*unsafe7
f10 = B - Zunsafe8*unsafe8
f11 = B - Zunsafe9*unsafe9
f12 = B - Zunsafe10*unsafe10
f13 = B - Zunsafe11*unsafe11
f14 = B - Zunsafe12*unsafe12
f15 = B - Zunsafe13*unsafe13
f16 = B - Zunsafe14*unsafe14
f17 = B - Zunsafe15*unsafe15


@constraint m f1 >= 0
@constraint m f2 >= 0
@constraint m f3 >= 1
@constraint m f4 >= 1
@constraint m f5 >= 1
@constraint m f6 >= 1
@constraint m f7 >= 1
@constraint m f8 >= 1
@constraint m f9 >= 1
@constraint m f10 >= 1
@constraint m f11 >= 1
@constraint m f12 >= 1
@constraint m f13 >= 1
@constraint m f14 >= 1
@constraint m f15 >= 1
@constraint m f16 >= 1
@constraint m f17 >= 1


status = solve(m)
print(STDERR,status)
print(STDERR,'#')
print(STDERR,getvalue(B))