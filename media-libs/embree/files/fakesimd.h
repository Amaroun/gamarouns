#include <array>
#include <cstdlib>
#include <math.h>
#include <type_traits>

//namespace fakesimd{

constexpr std::int32_t yes = 0xFFFFFFFF;
constexpr std::int32_t no = 0x0;

inline constexpr int32_t yes_no_i(bool value){return value? yes: no;}
inline float yes_no_s(bool value){float retVal = 0.f; reinterpret_cast<std::remove_cv<decltype(yes)>::type&>(retVal) = value? yes: no; return retVal;}

//}//namespace fakesimd

/* Create a selector for use with the SHUFPS instruction.  */
#define _MM_SHUFFLE(fp3,fp2,fp1,fp0) \
 (((fp3) << 6) | ((fp2) << 4) | ((fp1) << 2) | (fp0))


using __m128 = std::array<float,4>;
using __m128d = std::array<double,2>;
using __m128i = std::array<std::int32_t,4>;

inline __m128 _mm_undefined_ps() {return __m128();}
inline __m128i& _mm_castps_si128(__m128 &v){return reinterpret_cast<__m128i&>(v);}

inline __m128i const& _mm_castps_si128(__m128 const&v){return reinterpret_cast<__m128i const&>(v);}
inline __m128d const& _mm_castps_pd(__m128 const&v){return reinterpret_cast<__m128d const&>(v);}
inline __m128 const& _mm_castsi128_ps(__m128i const&v){return reinterpret_cast<__m128 const&>(v);}
inline __m128d const& _mm_castsi128_pd(__m128i const&v){return reinterpret_cast<__m128d const&>(v);}

inline __m128i _mm_cvtps_epi32 (__m128 a){__m128i retVal = {a[0],a[1],a[2],a[3]}; return retVal;}
inline __m128 _mm_cvtepi32_ps (__m128i a){__m128 retVal = {a[0],a[1],a[2],a[3]}; return retVal;}

inline __m128 _mm_setzero_ps (){__m128 retVal = {0.f,0.f,0.f,0.f}; return retVal;}
inline __m128i _mm_setzero_si128 (){__m128i retVal = {0,0,0,0}; return retVal;}

inline __m128 _mm_unpacklo_ps (__m128 a, __m128 b){__m128 retVal = {a[0],b[0],a[1],b[1]}; return retVal;}
inline __m128 _mm_unpackhi_ps (__m128 a, __m128 b){__m128 retVal = {a[2],b[2],a[3],b[3]}; return retVal;}

inline __m128 _mm_set_ss(float a){__m128 retVal = {a,0.f,0.f,0.f}; return retVal;}
inline __m128 _mm_rcp_ss(__m128 a){__m128 retVal = {1/a[0],a[1],a[2],a[3]}; return retVal;}
inline __m128 _mm_rsqrt_ss(__m128 a){__m128 retVal = {1/sqrt(a[0]),a[1],a[2],a[3]}; return retVal;}

inline __m128 _mm_div_ss (__m128 a, __m128 b){__m128 retVal = {a[0] / b[0],a[1],a[2],a[3]}; return retVal;}
inline __m128 _mm_mul_ss (__m128 a, __m128 b){__m128 retVal = {a[0] * b[0],a[1],a[2],a[3]}; return retVal;}
inline __m128 _mm_sub_ss (__m128 a, __m128 b){__m128 retVal = {a[0] - b[0],a[1],a[2],a[3]}; return retVal;}
inline __m128 _mm_add_ss (__m128 a, __m128 b){__m128 retVal = {a[0] + b[0],a[1],a[2],a[3]}; return retVal;}

inline __m128 _mm_rcp_ps(__m128 a){__m128 retVal = {1/a[0],1/a[1],1/a[2],1/a[3]}; return retVal;}
inline __m128 _mm_rsqrt_ps(__m128 a){__m128 retVal = {1/sqrt(a[0]),1/sqrt(a[1]),1/sqrt(a[2]),1/sqrt(a[3])}; return retVal;}
inline __m128 _mm_sqrt_ps(__m128 a){__m128 retVal = {sqrt(a[0]),sqrt(a[1]),sqrt(a[2]),sqrt(a[3])}; return retVal;}

inline __m128 _mm_div_ps (__m128 a, __m128 b){__m128 retVal = {a[0] / b[0],a[1] / b[1] ,a[2] / b[2],a[3] / b[3]}; return retVal;}
inline __m128 _mm_mul_ps (__m128 a, __m128 b){__m128 retVal = {a[0] * b[0],a[1] * b[1] ,a[2] * b[2],a[3] * b[3]}; return retVal;}
inline __m128 _mm_sub_ps (__m128 a, __m128 b){__m128 retVal = {a[0] - b[0],a[1] - b[1] ,a[2] - b[2],a[3] - b[3]}; return retVal;}
inline __m128 _mm_add_ps (__m128 a, __m128 b){__m128 retVal = {a[0] + b[0],a[1] + b[1] ,a[2] + b[2],a[3] + b[3]}; return retVal;}

inline __m128 _mm_min_ps (__m128 a, __m128 b){__m128 retVal = {std::min(a[0], b[0]), std::min(a[1], b[1]), std::min(a[2], b[2]), std::min(a[3], b[3])}; return retVal;}
inline __m128 _mm_max_ps (__m128 a, __m128 b){__m128 retVal = {std::max(a[0], b[0]), std::max(a[1], b[1]), std::max(a[2], b[2]), std::max(a[3], b[3])}; return retVal;}


inline __m128i _mm_mul_epi32 (__m128i a, __m128i b){__m128i retVal = {a[0] * b[0],a[1],a[2],a[3]}; return retVal;}
inline __m128i _mm_sub_epi32 (__m128i a, __m128i b){__m128i retVal = {a[0] - b[0],a[1],a[2],a[3]}; return retVal;}
inline __m128i _mm_add_epi32 (__m128i a, __m128i b){__m128i retVal = {a[0] + b[0],a[1],a[2],a[3]}; return retVal;}

inline float _mm_cvtss_f32 (__m128 a){return a[0];}
inline std::int32_t _mm_cvtsi128_si32 (__m128i a){return a[0];}
inline std::int64_t _mm_cvtsi128_si64 (__m128i a){return * reinterpret_cast<std::int64_t*>(a.data());}

inline __m128 _mm_set1_ps (float a){__m128 retVal = {a, a, a, a}; return retVal;}
inline __m128 _mm_set_ps (float e3, float e2, float e1, float e0){__m128 retVal = {e0, e1, e2, e3}; return retVal;}

inline __m128i _mm_set1_epi32 (int a){__m128i retVal = {a, a, a, a}; return retVal;}
inline __m128i _mm_set_epi32 (int e3, int e2, int e1, int e0){__m128i retVal = {e0, e1, e2, e3}; return retVal;}
inline __m128i _mm_set_epi64x (std::int64_t e1, std::int64_t e0)
{__m128i retVal;
*(reinterpret_cast<std::int64_t*>(retVal.data())) = e0;
*(reinterpret_cast<std::int64_t*>(retVal.data())+1) = e1;
return retVal;}

inline __m128 _mm_and_ps (__m128 a, __m128 b){__m128 retVal = {reinterpret_cast<std::int32_t&>(a[0])&reinterpret_cast<std::int32_t&>(b[0])
								, reinterpret_cast<std::int32_t&>(a[1])&reinterpret_cast<std::int32_t&>(b[1])
								, reinterpret_cast<std::int32_t&>(a[2])&reinterpret_cast<std::int32_t&>(b[2])
								, reinterpret_cast<std::int32_t&>(a[3])&reinterpret_cast<std::int32_t&>(b[3])}
						; return retVal;}
inline __m128 _mm_andnot_ps (__m128 a, __m128 b){__m128 retVal = {~reinterpret_cast<std::int32_t&>(a[0])&reinterpret_cast<std::int32_t&>(b[0])
								, ~reinterpret_cast<std::int32_t&>(a[1])&reinterpret_cast<std::int32_t&>(b[1])
								, ~reinterpret_cast<std::int32_t&>(a[2])&reinterpret_cast<std::int32_t&>(b[2])
								, ~reinterpret_cast<std::int32_t&>(a[3])&reinterpret_cast<std::int32_t&>(b[3])}
						; return retVal;}
inline __m128 _mm_xor_ps (__m128 a, __m128 b){__m128 retVal = {reinterpret_cast<std::int32_t&>(a[0])^reinterpret_cast<std::int32_t&>(b[0])
								, reinterpret_cast<std::int32_t&>(a[1])^reinterpret_cast<std::int32_t&>(b[1])
								, reinterpret_cast<std::int32_t&>(a[2])^reinterpret_cast<std::int32_t&>(b[2])
								, reinterpret_cast<std::int32_t&>(a[3])^reinterpret_cast<std::int32_t&>(b[3])}
						; return retVal;}
inline __m128 _mm_or_ps (__m128 a, __m128 b){__m128 retVal = {reinterpret_cast<std::int32_t&>(a[0])|reinterpret_cast<std::int32_t&>(b[0])
								, reinterpret_cast<std::int32_t&>(a[1])|reinterpret_cast<std::int32_t&>(b[1])
								, reinterpret_cast<std::int32_t&>(a[2])|reinterpret_cast<std::int32_t&>(b[2])
								, reinterpret_cast<std::int32_t&>(a[3])|reinterpret_cast<std::int32_t&>(b[3])}
						; return retVal;}

inline __m128i _mm_and_si128 (__m128i a, __m128i b){__m128i retVal = {a[0] & b[0], a[1] & b[1], a[2] & b[2], a[3] & b[3]}; return retVal;}
inline __m128i _mm_andnot_si128 (__m128i a, __m128i b){__m128i retVal = {~a[0] & b[0], ~a[1] & b[1], ~a[2] & b[2], ~a[3] & b[3]}; return retVal;}
inline __m128i _mm_xor_si128 (__m128i a, __m128i b){__m128i retVal = {a[0] ^ b[0], a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3]}; return retVal;}
inline __m128i _mm_or_si128 (__m128i a, __m128i b){__m128i retVal = {a[0] | b[0], a[1] | b[1], a[2] | b[2], a[3] | b[3]}; return retVal;}


inline std::int32_t _mm_movemask_ps (__m128 a){std::int32_t retVal = 0;
						for(int i = a.size() - 1; 0 <= i ; --i)
							{
								retVal |= reinterpret_cast<std::int32_t&>(a [i]) >> 31;
								retVal = retVal << 1;
							}
						return retVal;}

inline __m128i _mm_cmpeq_epi32 (__m128i a, __m128i b){__m128i retVal{yes_no_i(a[0] == b[0]), yes_no_i(a[1] == b[1]), yes_no_i(a[2] == b[2]), yes_no_i(a[3] == b[3])};return retVal;}
inline __m128i _mm_cmplt_epi32 (__m128i a, __m128i b){__m128i retVal{yes_no_i(a[0] < b[0]), yes_no_i(a[1] < b[1]), yes_no_i(a[2] < b[2]), yes_no_i(a[3] < b[3])};return retVal;}
inline __m128i _mm_cmpgt_epi32 (__m128i a, __m128i b){__m128i retVal{yes_no_i(a[0] > b[0]), yes_no_i(a[1] > b[1]), yes_no_i(a[2] > b[2]), yes_no_i(a[3] > b[3])};return retVal;}

inline __m128 _mm_cmpeq_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(a[0] == b[0]), yes_no_s(a[1] == b[1]), yes_no_s(a[2] == b[2]), yes_no_s(a[3] == b[3])};return retVal;}
inline __m128 _mm_cmplt_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(a[0] < b[0]), yes_no_s(a[1] < b[1]), yes_no_s(a[2] < b[2]), yes_no_s(a[3] < b[3])};return retVal;}
inline __m128 _mm_cmpgt_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(a[0] > b[0]), yes_no_s(a[1] > b[1]), yes_no_s(a[2] > b[2]), yes_no_s(a[3] > b[3])};return retVal;}

inline __m128 _mm_cmpneq_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(!(a[0] == b[0])), yes_no_s(!(a[1] == b[1])), yes_no_s(!(a[2] == b[2])), yes_no_s(!(a[3] == b[3]))};return retVal;}
inline __m128 _mm_cmpnlt_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(!(a[0] < b[0])), yes_no_s(!(a[1] < b[1])), yes_no_s(!(a[2] < b[2])), yes_no_s(!(a[3] < b[3]))};return retVal;}
inline __m128 _mm_cmpnle_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(!(a[0] <= b[0])), yes_no_s(!(a[1] <= b[1])), yes_no_s(!(a[2] <= b[2])), yes_no_s(!(a[3] <= b[3]))};return retVal;}
inline __m128 _mm_cmpngt_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(!(a[0] > b[0])), yes_no_s(!(a[1] > b[1])), yes_no_s(!(a[2] > b[2])), yes_no_s(!(a[3] > b[3]))};return retVal;}

inline __m128 _mm_cmpge_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(a[0] >= b[0]), yes_no_s(a[1] >= b[1]), yes_no_s(a[2] >= b[2]), yes_no_s(a[3] >= b[3])};return retVal;}
inline __m128 _mm_cmple_ps (__m128 a, __m128 b){__m128 retVal{yes_no_s(a[0] <= b[0]), yes_no_s(a[1] <= b[1]), yes_no_s(a[2] <= b[2]), yes_no_s(a[3] <= b[3])};return retVal;}


inline __m128i _mm_load_si128 (__m128i const* mem_addr)
{
__m128i retVal;
for(unsigned i = 0; i < retVal.size(); ++i)
	retVal[i] = (*mem_addr)[i];
return retVal;
}
inline __m128i _mm_loadu_si128 (__m128i const* mem_addr)
{
__m128i retVal;
for(unsigned i = 0; i < retVal.size(); ++i)
	retVal[i] = (*mem_addr)[i];
return retVal;
}

inline void _mm_store_si128 (__m128i* mem_addr, __m128i a)
{
for(unsigned i = 0; i < a.size(); ++i)
	(*mem_addr)[i] = a[i];
}
inline void _mm_storeu_si128 (__m128i* mem_addr, __m128i a)
{
for(unsigned i = 0; i < a.size(); ++i)
	(*mem_addr)[i] = a[i];
}

inline __m128 _mm_load_ps (__m128::const_pointer mem_addr)
{
__m128 retVal;
for(unsigned i = 0; i < retVal.size(); ++i)
	retVal[i] = mem_addr[i];
return retVal;
}
inline __m128 _mm_loadu_ps (__m128::const_pointer mem_addr)
{
__m128 retVal;
for(unsigned i = 0; i < retVal.size(); ++i)
	retVal[i] = mem_addr[i];
return retVal;
}

inline void _mm_store_ps (__m128::pointer mem_addr, __m128 a)
{
for(unsigned i = 0; i < a.size(); ++i)
	mem_addr[i] = a[i];
}
inline void _mm_storeu_ps (__m128::pointer mem_addr, __m128 a)
{
for(unsigned i = 0; i < a.size(); ++i)
	mem_addr[i] = a[i];
}

inline __m128i _mm_srli_si128 (__m128i a, int imm8)
{__m128i retVal;
if(imm8 > 15) imm8 = 16;
std::copy(reinterpret_cast<std::uint8_t*>(a.data()), reinterpret_cast<std::uint8_t*>(a.data()) + 16 - imm8, reinterpret_cast<std::uint8_t*>(retVal.data()));
std::fill(reinterpret_cast<std::uint8_t*>(retVal.data()) + 16 - imm8, reinterpret_cast<std::uint8_t*>(retVal.data()) + 16, 0);
return retVal;}

inline __m128i _mm_slli_epi32 (__m128i a, int imm8){__m128i retVal{a[0] << imm8, a[1] << imm8, a[2] << imm8, a[3] << imm8}; return retVal;}

inline __m128i _mm_srli_epi32 (__m128i a, int imm8){__m128i retVal{a[0] >> imm8, a[1] >> imm8, a[2] >> imm8, a[3] >> imm8}; return retVal;}

inline __m128i _mm_srai_epi32 (__m128i a, int imm8)
{__m128i retVal;
__m128i::value_type extend1 = 0xFFFFFFFF << (imm8 > 31? 0 : 32 - imm8 );
for(unsigned i = 0; i < a.size(); ++i)
	retVal[i] = (a[i] >> imm8) | (0 == (a[i] & 80000000)? 0 : extend1);
return retVal;}

inline __m128 _mm_shuffle_ps (__m128 a, __m128 b, std::uint32_t imm8)
{__m128 retVal{a[imm8 & 0x3], a[(imm8 >> 2) & 0x3], b[(imm8 >> 4) & 0x3], b[(imm8 >> 6) & 0x3]};return retVal;}

inline __m128i _mm_shuffle_epi32 (__m128i a, std::uint32_t imm8)
{__m128i retVal{a[imm8 & 0x3], a[(imm8 >> 2) & 0x3], a[(imm8 >> 4) & 0x3], a[(imm8 >> 6) & 0x3]};return retVal;}

#define _MM_HINT_T0 0
#define _MM_HINT_T1 0
#define _MM_HINT_T2 0
#define _MM_HINT_NTA 0
#define _MM_HINT_ENTA 0
#define _MM_HINT_ET0 0
#define _MM_HINT_ET1 0
#define _MM_HINT_ET2 0

inline void _mm_pause(){}
inline void _mm_prefetch (char const* p, int i){}

inline void* _mm_malloc(std::size_t size, std::size_t alig){return std::malloc(size);}
inline void _mm_free(void* p){std::free(p);}
