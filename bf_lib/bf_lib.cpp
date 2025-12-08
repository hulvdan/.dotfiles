#pragma once

#include <cmath>
#include <cstdarg>
#include <memory>

#include "bf_lib_instrument.cpp"

// ██████╗  █████╗ ███████╗███████╗
// ██╔══██╗██╔══██╗██╔════╝██╔════╝
// ██████╔╝███████║███████╗█████╗
// ██╔══██╗██╔══██║╚════██║██╔══╝
// ██████╔╝██║  ██║███████║███████╗
// ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝

#include <stdint.h>
#include <limits>
#include <utility>

#define UNUSED(x) (void)(x)

#define STATEMENT(statement) \
  do {                       \
    statement;               \
  } while (false)

#if (defined(__GNUC__) && !defined(__STRICT_ANSI__)) || defined(__cplusplus) \
  || defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L /* C99 */
#  define BF_INLINE_KEYWORD inline
#else
#  define BF_INLINE_KEYWORD
#endif

#if defined(__GNUC__) || defined(__ICCARM__)
#  define BF_FORCE_INLINE_ATTR __attribute__((always_inline))
#elif defined(_MSC_VER) && !defined(BF_LINT)
#  define BF_FORCE_INLINE_ATTR __forceinline
#else
#  define BF_FORCE_INLINE_ATTR
#endif

#define BF_FORCE_INLINE BF_INLINE_KEYWORD BF_FORCE_INLINE_ATTR

#if _WIN32 && !defined(BF_LINT)
#  define BF_FORCE_INLINE_LAMBDA noexcept [[msvc::forceinline]]
#elif defined(SDL_PLATFORM_EMSCRIPTEN)
#  define BF_FORCE_INLINE_LAMBDA
#elif __GNUC__ >= 4
#  define BF_FORCE_INLINE_LAMBDA noexcept __attribute__((always_inline))
#else
#  define BF_FORCE_INLINE_LAMBDA noexcept
#endif

#define LAMBDA(returnType_, name_, arguments) \
  const auto name_ = [&] arguments BF_FORCE_INLINE_LAMBDA -> returnType_

#define INLINE_LAMBDA [&]() BF_FORCE_INLINE_LAMBDA

#if defined(_MSC_VER)
#  define BF_RESTRICT __restrict
#elif defined(__GNUC__) || defined(__clang__)
#  define BF_RESTRICT __restrict__
#else
#  define BF_RESTRICT
#endif

#define BF_RELEASE (BF_DEBUG == 0)

#if defined(__clang__) && defined(__clang_minor__) && defined(__clang_patchlevel__)
#  define BF_COMPILER_CLANG (1)
#else
#  define BF_COMPILER_CLANG (0)
#endif

#define PTR_FROM_UINT(value) ((void*)((u8*)(nullptr) + (value)))
#define UINT_FROM_PTR(value) ((uintptr_t)((u8*)(value)))

#define MEMBER(T, m) (((T*)nullptr)->m)
#define OFFSET_OF_MEMBER(T, m) UINT_FROM_PTR(&Member(T, m))

#define ARRAY_COUNT(a) (int)(sizeof(a) / sizeof((a)[0]))

#define EMPTY_STATEMENT ((void)0)

// #define CONTINUE_LABEL_DANGER(name)           \
//   /*NOLINTBEGIN(bugprone-macro-parentheses)*/ \
//   if (0) {                                    \
//   name:                                       \
//     continue;                                 \
//   }                                           \
//   /*NOLINTEND(bugprone-macro-parentheses)*/   \
//   (void)0;

using void_func = void (*)();

using uint = unsigned int;
using u8   = uint8_t;
using i8   = int8_t;
using u16  = uint16_t;
using i16  = int16_t;
using u32  = uint32_t;
using i32  = int32_t;
using u64  = uint64_t;
using i64  = int64_t;
using f32  = float;
using f64  = double;

constexpr uint   uint_max   = std::numeric_limits<uint>::max();
constexpr u8     u8_max     = std::numeric_limits<u8>::max();
constexpr u16    u16_max    = std::numeric_limits<u16>::max();
constexpr u32    u32_max    = std::numeric_limits<u32>::max();
constexpr u64    u64_max    = std::numeric_limits<u64>::max();
constexpr size_t size_t_max = std::numeric_limits<size_t>::max();

constexpr int int_max = std::numeric_limits<int>::max();
constexpr i8  i8_max  = std::numeric_limits<i8>::max();
constexpr i16 i16_max = std::numeric_limits<i16>::max();
constexpr i32 i32_max = std::numeric_limits<i32>::max();
constexpr i64 i64_max = std::numeric_limits<i64>::max();

constexpr int int_min = std::numeric_limits<int>::min();
constexpr i8  i8_min  = std::numeric_limits<i8>::min();
constexpr i16 i16_min = std::numeric_limits<i16>::min();
constexpr i32 i32_min = std::numeric_limits<i32>::min();
constexpr i64 i64_min = std::numeric_limits<i64>::min();

constexpr f32 f32_inf = std::numeric_limits<f32>::infinity();
constexpr f64 f64_inf = std::numeric_limits<f64>::infinity();

// NOLINTBEGIN(bugprone-macro-parentheses)
#define FOR_RANGE(type, variable_name, max_value_exclusive) \
  for (type variable_name = 0; (variable_name) < (max_value_exclusive); variable_name++)
// NOLINTEND(bugprone-macro-parentheses)

#define INVALID_PATH ASSERT(false)
#define NOT_IMPLEMENTED ASSERT(false)
#define NOT_SUPPORTED ASSERT(false)

#define MIN(a, b) ((a) > (b) ? (b) : (a))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

#ifdef TESTS
#  define ASSERT(expr) CHECK(expr)
#  define ASSERT_FALSE(expr) CHECK_FALSE(expr)
#else  // TESTS
#  if BF_ENABLE_ASSERTS
#    if BF_COMPILER_CLANG
#      define ASSERT(expr)    \
        STATEMENT({           \
          if (!(bool)(expr))  \
            __builtin_trap(); \
        })
#    else
static volatile int _g_enable_asserts_work = 0;
#      include <assert.h>
#      define ASSERT(expr)                             \
        STATEMENT({                                    \
          if (!(bool)(expr)) {                         \
            _g_enable_asserts_work = *(int*)(nullptr); \
            assert(false);                             \
          }                                            \
        })
#    endif
#    define ASSERT_FALSE(expr) ASSERT(!(bool)(expr))
#  else
#    define ASSERT(expr) EMPTY_STATEMENT
#    define ASSERT_FALSE(expr) EMPTY_STATEMENT
#  endif  // BF_ENABLE_ASSERTS
#endif    // TESTS

#define ASSERT_IS_NUMBER(v) \
  ASSERT((v) != f32_inf);   \
  ASSERT((v) != -f32_inf);

#ifndef TEST_CASE
#  define h_with_counter_(counter) h_##counter
#  define h_(counter) h_with_counter_(counter)
#  define TEST_CASE(...) void h_(__COUNTER__)()
#endif

#ifndef CHECK
#  define CHECK
#endif

// #ifndef ZoneScoped
// #  define ZoneScoped
// #endif
//
// #ifndef ZoneScopedN
// #  define ZoneScopedN
// #endif
//
// #ifndef FrameMark
// #  define FrameMark
// #endif

//----------------------------------------------------------------------------------
// Defer.
//----------------------------------------------------------------------------------
template <typename F>
// NOLINTNEXTLINE(cppcoreguidelines-special-member-functions)
struct Defer_ {
  explicit BF_FORCE_INLINE Defer_(F f)
      : f(f) {}
  BF_FORCE_INLINE ~Defer_() {
    f();
  }
  F f;
};

template <typename F>
BF_FORCE_INLINE Defer_<F> makeDefer_(F f) {
  return Defer_<F>(f);
}

#define defer_with_counter_(counter) defer_##counter
#define defer_(counter) defer_with_counter_(counter)

struct defer_dummy_ {};

template <typename F>
// NOLINTNEXTLINE(cppcoreguidelines-missing-std-forward)
Defer_<F> operator+(defer_dummy_, F&& f) {
  return makeDefer_<F>(std::forward<F>(f));
}

// NOLINTNEXTLINE(bugprone-macro-parentheses)
#define DEFER auto defer_(__COUNTER__) = defer_dummy_() + [&]() BF_FORCE_INLINE_LAMBDA

//----------------------------------------------------------------------------------
// Iterators.
//----------------------------------------------------------------------------------
//
// NOTE: Proudly taken from
// https://vector-of-bool.github.io/2020/06/13/cpp20-iter-facade.html
template <class Reference>
struct ArrowProxy {  ///
  Reference  r;
  Reference* operator->() {
    return &r;
  }
};

// Usage:
//
//     struct A : public Equatable<A> {
//         int field1;
//         int field2;
//
//         [[nodiscard]] bool EqualTo(const A& other) const {
//             auto result = (
//                 (field1 == other.field1)
//                 && (field2 == other.field2)
//             );
//             return result;
//         }
//     }
//
template <typename Derived>
struct Equatable {  ///
  private:
  using SelfType = Derived;

  public:
  friend bool operator==(const SelfType& v1, const SelfType& v2) {
    return v1.EqualTo(v2);
  }
  // SHIT: Fuken `clang-tidy` requires this function to be specified
  friend bool operator!=(const SelfType& v1, const SelfType& v2) {
    return !v1.EqualTo(v2);
  }
};

template <typename Derived>
struct IteratorFacade {  ///
  protected:
  using SelfType = Derived;

  private:
  SelfType& _self() {
    return static_cast<SelfType&>(*this);
  }
  [[nodiscard]] const SelfType& _self() const {
    return static_cast<const SelfType&>(*this);
  }

  public:
  decltype(auto) operator*() const {
    return _self().Dereference();
  }

  auto operator->() const {
    decltype(auto) ref = **this;
    if constexpr (std::is_reference_v<decltype(ref)>)
      return std::addressof(ref);
    else
      return ArrowProxy<Derived>(std::move(ref));
  }

  friend bool operator==(const SelfType& v1, const SelfType& v2) {
    return v1.EqualTo(v2);
  }
  // SHIT: Fuken `clang-tidy` requires this function to be specified
  friend bool operator!=(const SelfType& v1, const SelfType& v2) {
    return !v1.EqualTo(v2);
  }

  SelfType& operator++() {
    _self().Increment();
    return _self();
  }

  SelfType operator++(int) {
    auto copy = _self();
    ++*this;
    return copy;
  }
};

// ███╗   ███╗ █████╗ ████████╗██╗  ██╗
// ████╗ ████║██╔══██╗╚══██╔══╝██║  ██║
// ██╔████╔██║███████║   ██║   ███████║
// ██║╚██╔╝██║██╔══██║   ██║   ██╔══██║
// ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║
// ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝

constexpr auto SQRT_2        = 1.41421356237f;
constexpr auto SQRT_2_OVER_2 = 0.70710678f;

#ifndef PI32
#  define PI32 (3.14159265358979323846f)
#endif
#ifndef PI64
#  define PI64 (3.14159265358979323846)
#endif

bool FloatEquals(f32 v1, f32 v2) {  ///
  return abs(v1 - v2) < 0.00001f;
}

f32 Unlerp(f32 value, f32 rangeMin, f32 rangeMax) {  ///
  ASSERT_IS_NUMBER(value);
  ASSERT_IS_NUMBER(rangeMin);
  ASSERT_IS_NUMBER(rangeMax);

  auto v1 = (value - rangeMin);
  auto v2 = (rangeMax - rangeMin);
  return v1 / v2;
}

TEST_CASE ("Unlerp") {  ///
  auto v = Unlerp(18.0f, 10.0f, 20.0f);
  ASSERT(FloatEquals(v, 0.8f));
}

#define REVOLUTIONS2RAD (3.14159265358979f)
#define REVOLUTIONS2DEG (3.14159265358979f * (RAD2DEG))

#define SIGN(X) ((X) == 0 ? 0 : ((X) < 0 ? -1 : 1))

int Round(f32 value) {  ///
  return lround(value);
}

f32 MoveTowardsF(f32 v, f32 target, f32 maxDistance) {  ///
  ASSERT(maxDistance >= 0);

  if (v > target) {
    v -= maxDistance;
    if (v < target)
      v = target;
  }
  else if (v < target) {
    v += maxDistance;
    if (v > target)
      v = target;
  }

  return v;
}

int MoveTowardsI(int v, int target, int maxDistance) {  ///
  ASSERT(maxDistance >= 0);

  if (v > target) {
    v -= maxDistance;
    if (v < target)
      v = target;
  }
  else if (v < target) {
    v += maxDistance;
    if (v > target)
      v = target;
  }

  return v;
}

TEST_CASE ("MoveTowards") {  ///
  ASSERT(MoveTowardsI(0, 10, 5) == 5);
  ASSERT(MoveTowardsI(-10, 10, 5) == -5);
  ASSERT(MoveTowardsI(10, -10, 5) == 5);
  ASSERT(MoveTowardsI(0, 10, 30) == 10);
  ASSERT(MoveTowardsI(-10, 10, 30) == 10);
  ASSERT(MoveTowardsI(10, -10, 30) == -10);

  ASSERT(MoveTowardsF(0, 10, 5) == 5);
  ASSERT(MoveTowardsF(-10, 10, 5) == -5);
  ASSERT(MoveTowardsF(10, -10, 5) == 5);
  ASSERT(MoveTowardsF(0, 10, 30) == 10);
  ASSERT(MoveTowardsF(-10, 10, 30) == 10);
  ASSERT(MoveTowardsF(10, -10, 30) == -10);
}

//  [0; 360)
f32 NormalizeAngleDeg0360(f32 a) {  ///
  ASSERT_IS_NUMBER(a);
  a = fmodf(a, 360);
  if (a < 0)
    a += 360;
  return a;
}

// [-180; 180)
f32 NormalizeAngleDeg180180(f32 a) {  ///
  ASSERT_IS_NUMBER(a);
  a = fmodf(a + 180, 360);
  if (a < 0)
    a += 360;
  return a - 180;
}

// [-180; 180)
f32 AngleDiffDeg(f32 a, f32 b) {  ///
  ASSERT_IS_NUMBER(a);
  ASSERT_IS_NUMBER(b);
  return NormalizeAngleDeg180180(b - a);
}

f32 BisectAngleDeg(f32 a, f32 b) {  ///
  ASSERT_IS_NUMBER(a);
  ASSERT_IS_NUMBER(b);
  return NormalizeAngleDeg0360(a + AngleDiffDeg(a, b) * 0.5f);
}

bool FloatAngleDegreesEquals(f32 a1, f32 a2) {  ///
  ASSERT_IS_NUMBER(a1);
  ASSERT_IS_NUMBER(a2);
  a1 = NormalizeAngleDeg0360(a1);
  a2 = NormalizeAngleDeg0360(a2);
  return a1 == a2;
}

TEST_CASE ("BisectAngleDeg") {  ///
  const struct {
    f32 a, b, c;
  } r[] = {
    {90.0f, 0.0f, 45.0f},
    {90.0f, 60.0f, 75.0f},
    {180.0f, 2.0f, 91.0f},
    {180.0f, -2.0f, -91.0f},
  };
  for (auto [a, b, c] : r) {
    auto res = BisectAngleDeg(a, b);
    CHECK(FloatAngleDegreesEquals(res, c));
    auto res2 = BisectAngleDeg(a, b);
    CHECK(FloatAngleDegreesEquals(res2, c));
  }
}

f32 MoveTowardsFAngleDeg(f32 a1, f32 a2, f32 maxAngle) {  ///
  ASSERT_IS_NUMBER(a1);
  ASSERT_IS_NUMBER(a2);
  ASSERT_IS_NUMBER(maxAngle);
  ASSERT(maxAngle >= 0);

  auto diff = AngleDiffDeg(a1, a2);
  auto d    = MoveTowardsF(0, diff, maxAngle);
  auto res  = a1 + d;
  return res;
}

TEST_CASE ("MoveTowardsFAngleDeg") {  ///
  const struct {
    int a, b, c, d;
  } r[] = {
    {1, 0, 5, 0},
    {-1, 0, 5, 0},
    {361, 0, 5, 0},
    {-361, 0, 5, 0},
    {90, 0, 5, 85},
    {-90, 0, 5, -85},
    {181, 0, 5, 186},
    {181, 90, 5, 176},
    {179, 0, 5, 174},
    {179, 180, 5, 180},
    {90, 180, 5, 95},
  };
  for (auto [a, b, c, d] : r) {
    auto res = MoveTowardsFAngleDeg((f32)a, (f32)b, (f32)c);
    CHECK(FloatAngleDegreesEquals(res, (f32)d));
  }
}

// ExponentialDecay - это ~Lerp, но без зависимости от framerate-а.
// NOTE: https://www.youtube.com/watch?v=LSNQuFEDOyQ
f32 ExponentialDecay(f32 a, f32 b, f32 decay, f32 dt) {  ///
  return b + (a - b) * expf(-decay * dt);
}

int Floor(int number, int factor) {  ///
  int result = (number / factor) * factor;
  if (number < 0 && number % factor != 0) {
    result -= factor;
  }
  return result;
}

TEST_CASE ("Floor") {  ///
  ASSERT(Floor(0, 20) == 0);
  ASSERT(Floor(1, 20) == 0);
  ASSERT(Floor(-1, 20) == -20);
  ASSERT(Floor(20, 20) == 20);
  ASSERT(Floor(21, 20) == 20);
}

int Ceil(f64 value) {  ///
  auto result = (int)std::ceil(value);
  return result;
}

int Ceilf(f32 value) {  ///
  auto result = (int)std::ceilf(value);
  return result;
}

int Floor(f64 value) {  ///
  auto result = (int)std::floor(value);
  return result;
}

int Floorf(f32 value) {  ///
  auto result = (int)std::floorf(value);
  return result;
}

u64 CeilDivisionU64(u64 value, u64 divisor) {  ///
  ASSERT(value >= 0);
  ASSERT(divisor > 0);
  return value / divisor + ((value % divisor) != 0);
}

int CeilDivision(int value, int divisor) {  ///
  ASSERT(value >= 0);
  ASSERT(divisor > 0);
  return value / divisor + ((value % divisor) != 0);
}

TEST_CASE ("CeilDivision") {  ///
  ASSERT(CeilDivision(10, 1) == 10);
  ASSERT(CeilDivision(10, 5) == 2);
  ASSERT(CeilDivision(10, 6) == 2);
  ASSERT(CeilDivision(10, 4) == 3);
}

f32 GetLesserAngle(f32 aa, f32 bb) {  ///
  auto a = aa;
  auto b = bb;
  while (a < -PI32)
    a += 2 * PI32;
  while (b < -PI32)
    b += 2 * PI32;
  while (a >= PI32)
    a -= 2 * PI32;
  while (b >= PI32)
    b -= 2 * PI32;

  if (abs(a) > abs(b))
    return bb;
  return aa;
}

TEST_CASE ("GetLesserAngle") {  ///
  ASSERT(FloatEquals(GetLesserAngle(PI32 * 1 / 2, PI32), PI32 * 1 / 2));
  ASSERT(FloatEquals(GetLesserAngle(-PI32 * 1 / 2, PI32), -PI32 * 1 / 2));
  ASSERT(FloatEquals(GetLesserAngle(PI32 / 2, PI32 * 15 / 8), PI32 * 15 / 8));
}

f32 Clamp(f32 value, f32 min, f32 max) {  ///
  ASSERT_IS_NUMBER(min);
  ASSERT_IS_NUMBER(max);
  ASSERT(min <= max);
  if (value < min)
    return min;
  if (max < value)
    return max;
  return value;
}

f32 Clamp01(f32 value) {  ///
  return Clamp(value, 0, 1);
}

f32 Clamp11(f32 value) {  ///
  return Clamp(value, -1, 1);
}

int ClampInt(int value, int min, int max) {  ///
  ASSERT(min <= max);
  if (value < min)
    return min;
  if (value > max)
    return max;
  return value;
}

TEST_CASE ("ClampInt") {  ///
  ASSERT(ClampInt(2, 1, 3) == 2);
  ASSERT(ClampInt(0, 1, 3) == 1);
  ASSERT(ClampInt(4, 1, 3) == 3);
  ASSERT(ClampInt(1, 1, 3) == 1);
  ASSERT(ClampInt(3, 1, 3) == 3);
}

#define QUERY_BIT(bytesPtr, bitIndex) \
  ((*((u8*)(bytesPtr) + ((bitIndex) / 8))) & (1 << ((bitIndex) % 8)))

#define MARK_BIT(bytesPtr, bitIndex)                  \
  STATEMENT({                                         \
    u8& byte = *((u8*)(bytesPtr) + ((bitIndex) / 8)); \
    byte     = byte | (1 << ((bitIndex) % 8));        \
  })

#define UNMARK_BIT(bytesPtr, bitIndex)                \
  STATEMENT({                                         \
    u8& byte = *((u8*)(bytesPtr) + ((bitIndex) / 8)); \
    byte &= 0xFF - (1 << ((bitIndex) % 8));           \
  })

TEST_CASE ("Bit operations") {  ///
  {
    const struct {
      u8 a, b, c;
    } marks[] = {
      {0b00000000, 0, 0b00000001},
      {0b00000000, 1, 0b00000010},
      {0b00000000, 2, 0b00000100},
      {0b00000000, 7, 0b10000000},
    };
    for (auto& [initialValue, index, afterValue] : marks) {
      u8  byte  = initialValue;
      u8* bytes = &byte;
      MARK_BIT(bytes, index);
      CHECK(byte == afterValue);
      UNMARK_BIT(bytes, index);
      CHECK(byte == initialValue);
    }
  }

  {
    const struct {
      u8 a, b, c;
    } unmarks[] = {
      {0b11111111, 0, 0b11111110},
      {0b11111111, 1, 0b11111101},
      {0b11111111, 2, 0b11111011},
      {0b11111111, 7, 0b01111111},
    };
    for (auto& [initialValue, index, afterValue] : unmarks) {
      u8  byte  = initialValue;
      u8* bytes = &byte;
      UNMARK_BIT(bytes, index);
      CHECK(byte == afterValue);
      MARK_BIT(bytes, index);
      CHECK(byte == initialValue);
    }
  }

  {
    u8 ptr[] = {
      0b00000000,
      0b01000001,
    };
    CHECK((bool)QUERY_BIT(ptr, 0) == false);
    CHECK((bool)QUERY_BIT(ptr, 8) == true);
    CHECK((bool)QUERY_BIT(ptr, 14) == true);
  }
}

// Usage Examples:
//     32 -> 32
//     26 -> 32
//     13 -> 16
//     8 -> 8
//     0 -> ASSERT
//     2147483648 and above -> ASSERT
u32 CeilToPowerOf2(u32 value) {  ///
  ASSERT(value <= 2147483648);
  ASSERT(value != 0);

  u32 ceiledValue = 1;
  while (ceiledValue < value)
    ceiledValue *= 2;

  return ceiledValue;
}

TEST_CASE ("CeilToPowerOf2") {  ///
  CHECK(CeilToPowerOf2(1) == 1);
  CHECK(CeilToPowerOf2(2) == 2);
  CHECK(CeilToPowerOf2(3) == 4);
  CHECK(CeilToPowerOf2(4) == 4);
  CHECK(CeilToPowerOf2(31) == 32);
  CHECK(CeilToPowerOf2(32) == 32);
  CHECK(CeilToPowerOf2(65535) == 65536);
  CHECK(CeilToPowerOf2(65536) == 65536);
  CHECK(CeilToPowerOf2(2147483647) == 2147483648);
  CHECK(CeilToPowerOf2(2147483648) == 2147483648);
}

// Проверка на то, является ли число степенью двойки.
// При передаче указателя на power, там окажется значение этой степени.
bool IsPowerOf2(u32 number, int* power = nullptr) {  ///
  if (number == 0)
    return false;

  if (power)
    *power = 0;

  while (number > 1) {
    if (number & 1)
      return false;

    number >>= 1;
    if (power)
      *power += 1;
  }

  return true;
}

TEST_CASE ("IsPowerOf2") {  ///
  int power = 0;

  ASSERT(IsPowerOf2(2, &power));
  ASSERT(power == 1);
  ASSERT(IsPowerOf2(4, &power));
  ASSERT(power == 2);
  ASSERT(IsPowerOf2(1, &power));
  ASSERT(power == 0);

  ASSERT_FALSE(IsPowerOf2(-1, &power));
  ASSERT_FALSE(IsPowerOf2(0, &power));
  ASSERT_FALSE(IsPowerOf2(3, &power));
}

// NOTE: bounds are EXCLUSIVE.
#define POS_IS_IN_BOUNDS(pos, bounds) \
  (!((pos).x < 0 || (pos).x >= (bounds).x || (pos).y < 0 || (pos).y >= (bounds).y))

BF_FORCE_INLINE Vector2 Vector2Lerp(Vector2 v1, Vector2 v2, f32 amount) {  ///
  return v1 + (v2 - v1) * amount;
}

BF_FORCE_INLINE Vector2
Bezier(Vector2 v1, Vector2 v2, Vector2 v3, Vector2 v4, f32 t) {  ///
  ASSERT(t >= 0);
  ASSERT(t <= 1);

  auto a1 = Vector2Lerp(v1, v2, t);
  auto a2 = Vector2Lerp(v2, v3, t);
  auto a3 = Vector2Lerp(v3, v4, t);

  auto b1 = Vector2Lerp(a1, a2, t);
  auto b2 = Vector2Lerp(a2, a3, t);

  auto c = Vector2Lerp(b1, b2, t);
  return c;
}

using Easing_function_t = f32 (*)(f32);

f32 EaseLinear(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return p;
}

f32 EaseInQuad(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return p * p;
}

f32 EaseOutQuad(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return -(p * (p - 2));
}

f32 EaseInOutQuad(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 0.5)
    return 2 * p * p;
  else
    return (-2 * p * p) + (4 * p) - 1;
}

f32 EaseInCubic(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return p * p * p;
}

f32 EaseOutCubic(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  f32 f = (p - 1);
  return f * f * f + 1;
}

f32 EaseInOutCubic(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 0.5f)
    return 4 * p * p * p;
  else {
    f32 f = ((2 * p) - 2);
    return 0.5f * f * f * f + 1;
  }
}

f32 EaseInQuart(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return p * p * p * p;
}

f32 EaseOutQuart(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  f32 f = (p - 1);
  return f * f * f * (1 - p) + 1;
}

f32 EaseInOutQuart(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 0.5)
    return 8 * p * p * p * p;
  else {
    f32 f = (p - 1);
    return -8 * f * f * f * f + 1;
  }
}

f32 EaseInQuint(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return p * p * p * p * p;
}

f32 EaseOutQuint(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  f32 f = (p - 1);
  return f * f * f * f * f + 1;
}

f32 EaseInOutQuint(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 0.5f)
    return 16 * p * p * p * p * p;
  else {
    f32 f = ((2 * p) - 2);
    return 0.5f * f * f * f * f * f + 1;
  }
}

f32 EaseInSin(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return sinf((p - 1) * 2 * PI32) + 1;
}

f32 EaseOutSin(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return sinf(p * 2 * PI32);
}

f32 EaseInOutSin(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return 0.5f * (1 - cosf(p * PI32));
}

f32 EaseInCirc(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return 1 - sqrtf(1 - (p * p));
}

f32 EaseOutCirc(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return sqrtf((2 - p) * p);
}

f32 EaseInOutCirc(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 0.5f)
    return 0.5f * (1 - sqrtf(1 - 4 * (p * p)));
  else
    return 0.5f * (sqrtf(-((2 * p) - 3) * ((2 * p) - 1)) + 1);
}

f32 EaseInExpo(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return (p == 0.0f) ? p : powf(2, 10 * (p - 1));
}

f32 EaseOutExpo(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return (p == 1.0f) ? p : 1 - powf(2, -10 * p);
}

f32 EaseInOutExpo(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p == 0.0f || p == 1.0f)
    return p;
  if (p < 0.5f)
    return 0.5f * powf(2, (20 * p) - 10);
  else
    return -0.5f * powf(2, (-20 * p) + 10) + 1;
}

f32 EaseInElastic(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return sinf(13 * 2 * PI32 * p) * powf(2, 10 * (p - 1));
}

f32 EaseOutElastic(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return sinf(-13 * 2 * PI32 * (p + 1)) * powf(2, -10 * p) + 1;
}

f32 EaseInOutElastic(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 0.5f)
    return 0.5f * sinf(13 * 2 * PI32 * (2 * p)) * powf(2, 10 * ((2 * p) - 1));
  else
    return 0.5f
           * (sinf(-13 * 2 * PI32 * ((2 * p - 1) + 1)) * powf(2, -10 * (2 * p - 1)) + 2);
}

f32 EaseInBack(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return p * p * p - p * sinf(p * PI32);
}

f32 EaseOutBack(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  f32 f = (1 - p);
  return 1 - (f * f * f - f * sinf(f * PI32));
}

f32 EaseInOutBack(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 0.5f) {
    f32 f = 2 * p;
    return 0.5f * (f * f * f - f * sinf(f * PI32));
  }
  else {
    f32 f = (1 - (2 * p - 1));
    return 0.5f * (1 - (f * f * f - f * sinf(f * PI32))) + 0.5f;
  }
}

f32 EaseOutBounce(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 4 / 11.0f)
    return (121 * p * p) / 16.0f;
  else if (p < 8 / 11.0f)
    return (363 / 40.0f * p * p) - (99 / 10.0f * p) + 17 / 5.0f;
  else if (p < 9 / 10.0)
    return (4356 / 361.0f * p * p) - (35442 / 1805.0f * p) + 16061 / 1805.0f;
  else
    return (54 / 5.0f * p * p) - (513 / 25.0f * p) + 268 / 25.0f;
}

f32 EaseInBounce(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return 1 - EaseOutBounce(1 - p);
}

f32 EaseInOutBounce(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  if (p < 0.5f)
    return 0.5f * EaseInBounce(p * 2);
  else
    return 0.5f * EaseOutBounce(p * 2 - 1) + 0.5f;
}

f32 EaseABitUpThenDown(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  /*
  [[[cog
  import numpy as np
  k = np.polyfit([0, 0.3, 1], [0, 1, -2], 2)
  cog.outl("return {:.6f}f * p * p + {:.6f}f * p + {:.6f}f;".format(*k))
  ]]] */
  return -7.619048f * p * p + 5.619048f * p + -0.000000f;
  /* [[[end]]] */
}

f32 EaseBounceThenZero(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  /*
  [[[cog
  import numpy as np
  k = np.polyfit([0, 0.5, 1], [0, 1, 0], 2)
  cog.outl("return {:.6f}f * p * p + {:.6f}f * p + {:.6f}f;".format(*k))
  ]]] */
  return -4.000000f * p * p + 4.000000f * p + 0.000000f;
  /* [[[end]]] */
}

f32 EaseBounceSmall(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  /*
  [[[cog
  import numpy as np
  k = np.polyfit([0, 0.5, 1], [0, 1.025, 1], 2)
  cog.outl("return {:.6f}f * p * p + {:.6f}f * p + {:.6f}f;".format(*k))
  ]]] */
  return -2.100000f * p * p + 3.100000f * p + 0.000000f;
  /* [[[end]]] */
}

BF_FORCE_INLINE f32 EaseBounceSmallSmooth(f32 p) {  ///
  ASSERT_IS_NUMBER(p);
  return Bezier({0, 0}, {0.8f, 1.8f}, {0.8f, 0.9f}, {1, 1}, p).y;
}

#define OFFSET_IN_DIRECTION_OF_ANGLE_RAD(offset, angleRad) \
  (Vector2Rotate(Vector2((offset), 0), (angleRad)))
#define OFFSET_IN_DIRECTION_OF_ANGLE_DEG(offset, angleDeg) \
  OFFSET_IN_DIRECTION_OF_ANGLE_RAD((offset), (angleDeg) * DEG2RAD)

f32 Lerp(f32 start, f32 end, f32 amount) {  ///
  ASSERT_IS_NUMBER(start);
  ASSERT_IS_NUMBER(end);
  ASSERT_IS_NUMBER(amount);

  return start + amount * (end - start);
}

f32 Remap(f32 v, f32 range1min, f32 range1max, f32 range2min, f32 range2max) {  ///
  ASSERT_IS_NUMBER(v);
  ASSERT_IS_NUMBER(range1min);
  ASSERT_IS_NUMBER(range1max);
  ASSERT_IS_NUMBER(range2min);
  ASSERT_IS_NUMBER(range2max);

  const auto t = Unlerp(v, range1min, range1max);
  return Lerp(range2min, range2max, t);
}

TEST_CASE ("Remap") {  ///
  ASSERT(FloatEquals(Remap(18.0f, 10.0f, 20.0f, 5.0f, 10.0f), 9.0f));
}

Vector2 Vector2ExponentialDecay(Vector2 a, Vector2 b, f32 decay, f32 dt) {  ///
  ASSERT_IS_NUMBER(decay);
  ASSERT_IS_NUMBER(dt);
  return b + (a - b) * expf(-decay * dt);
}

Vector3 Vector3ExponentialDecay(Vector3 a, Vector3 b, f32 decay, f32 dt) {  ///
  ASSERT_IS_NUMBER(decay);
  ASSERT_IS_NUMBER(dt);
  return b + (a - b) * expf(-decay * dt);
}

f32 InOutLerp(f32 from, f32 to, f32 elapsed, f32 totalDuration, f32 easeDuration) {  ///
  ASSERT_IS_NUMBER(from);
  ASSERT_IS_NUMBER(to);
  ASSERT_IS_NUMBER(elapsed);
  ASSERT_IS_NUMBER(totalDuration);
  ASSERT_IS_NUMBER(easeDuration);
  ASSERT(easeDuration * 2 <= totalDuration);

  if (elapsed < easeDuration) {
    auto p = elapsed / easeDuration;
    return Lerp(from, to, p);
  }
  else if (elapsed > totalDuration - easeDuration) {
    auto p = 1 - (elapsed - (totalDuration - easeDuration)) / easeDuration;
    return Lerp(from, to, p);
  }
  ASSERT(elapsed <= totalDuration);
  return to;
}

constexpr u32 EMPTY_HASH32 = 0x811c9dc5;

u32 Hash32(const u8* key, const int len) {  ///
  ASSERT(len >= 0);

  // Wiki: https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function
  auto hash = EMPTY_HASH32;
  FOR_RANGE (int, i, len) {
    // hash = (hash * 16777619) ^ (*key);  // FNV-1
    hash = (hash ^ (*key)) * 0x01000193;  // FNV-1a
    key++;
  }

  return hash;
}

u32 Hash32_ZeroTerminatedString(const char* key) {  ///
  auto hash = EMPTY_HASH32;
  while (*key) {
    // hash = (hash * 16777619) ^ (*key);  // FNV-1
    hash = (hash ^ (*key)) * 0x01000193;  // FNV-1a
    key++;
  }

  return hash;
}

void IncrementSetZeroOn(int* value, int mod) {  ///
  *value = *value + 1;

  if (*value >= mod)
    *value = 0;
}

// NOTE: `start` and `end` values must be accessible via `step`!
int ArithmeticSum(int start, int end, int step = 1) {  ///
  ASSERT_FALSE((end - start) % step);
  if (end >= start) {
    ASSERT(step > 0);
    return (start + end) * (end - start + 1) / 2;
  }
  else if (end < start) {
    ASSERT(step < 0);
    return (start + end) * (start - end + 1) / 2;
  }
  INVALID_PATH;
  return 0;
}

TEST_CASE ("ArithmeticSum") {  ///
  ASSERT(ArithmeticSum(1, 1) == 1);
  ASSERT(ArithmeticSum(2, 2) == 2);
  ASSERT(ArithmeticSum(1, 4) == 10);
  ASSERT(ArithmeticSum(4, 1, -1) == 10);
  ASSERT(ArithmeticSum(1, 5) == 15);
  ASSERT(ArithmeticSum(2, 5) == 14);
}

// NOTE: `start` and `end` values must be accessible via `step`!
f32 ArithmeticSumAverage(int start, int end, int step = 1) {  ///
  int sum = ArithmeticSum(start, end, step);
  if (start > end) {
    auto t = start;
    start  = end;
    end    = t;
  }
  return (f32)sum / (f32)(end - start + 1);
}

TEST_CASE ("AverageOfArithmeticSum") {  ///
  ASSERT(FloatEquals(ArithmeticSumAverage(1, 4), 2.5f));
  ASSERT(FloatEquals(ArithmeticSumAverage(4, 1, -1), 2.5f));
  ASSERT(FloatEquals(ArithmeticSumAverage(1, 5), 3.0f));
  ASSERT(FloatEquals(ArithmeticSumAverage(2, 5), 3.5f));
}

constexpr Vector2 Vector2Zero() {  ///
  return Vector2{0, 0};
}

constexpr Vector2 Vector2Half() {  ///
  return Vector2{0.5f, 0.5f};
}

constexpr Vector2 Vector2One() {  ///
  return Vector2{1, 1};
}

constexpr Vector2 Vector2Inf() {  ///
  return Vector2{f32_inf, f32_inf};
}

f32 Vector2Length(Vector2 v) {  ///
  return glm::length(v);
}

f32 Vector2LengthSqr(Vector2 v) {  ///
  return v.x * v.x + v.y * v.y;
}

f32 Vector2Dot(Vector2 v1, Vector2 v2) {  ///
  return glm::dot(v1, v2);
}

f32 Vector2Distance(Vector2 v1, Vector2 v2) {  ///
  return Vector2Length(v2 - v1);
}

f32 Vector2DistanceSqr(Vector2 v1, Vector2 v2) {  ///
  return Vector2LengthSqr(v2 - v1);
}

f32 Vector2Angle(Vector2 v) {  ///
  ASSERT(v != Vector2Zero());
  return atan2f(v.y, v.x);
}

f32 Vector2AngleOrZero(Vector2 v) {  ///
  if (v == Vector2Zero())
    return 0;
  return atan2f(v.y, v.x);
}

f32 Vector2Angle(Vector2 v1, Vector2 v2) {  ///
  auto a1 = atan2f(v1.y, v1.x);
  auto a2 = atan2f(v2.y, v2.x);
  return a2 - a1;
}

Vector2 Vector2Normalize(Vector2 v) {  ///
  return glm::normalize(v);
}

Vector2 Vector2Reflect(Vector2 v, Vector2 normal) {  ///
  return glm::reflect(v, normal);
}

Vector2 Vector2Rotate(Vector2 v, f32 angle) {  ///
  auto c = cosf(angle);
  auto s = sinf(angle);
  return {v.x * c - v.y * s, v.x * s + v.y * c};
}

bool Vector2Equals(Vector2 v1, Vector2 v2) {  ///
  return FloatEquals(v1.x, v2.x) && FloatEquals(v1.y, v2.y);
}

bool Vector3Equals(Vector3 v1, Vector3 v2) {  ///
  return FloatEquals(v1.x, v2.x) && FloatEquals(v1.y, v2.y) && FloatEquals(v1.z, v2.z);
}

Vector2 Vector2MoveTowardsF(Vector2 v, Vector2 target, f32 maxDistance) {  ///
  if (Vector2Equals(v, target))
    return target;

  auto d = Vector2Normalize(target - v);
  v.x    = MoveTowardsF(v.x, target.x, d.x * maxDistance);
  v.y    = MoveTowardsF(v.y, target.y, d.y * maxDistance);
  return v;
}

Vector2 Vector2Invert(Vector2 v) {  ///
  return {1.0f / v.x, 1.0f / v.y};
}

Vector2 Vector2Clamp(Vector2 v, Vector2 min, Vector2 max) {  ///
  return glm::clamp(v, min, max);
}

Vector2 Vector2ClampValue(Vector2 v, f32 min, f32 max) {  ///
  return glm::clamp(v, min, max);
}

constexpr f32 ScaleToFit(Vector2 inner, Vector2 container) {  ///
  f32 scaleX = container.x / inner.x;
  f32 scaleY = container.y / inner.y;
  f32 scale  = (scaleX < scaleY) ? scaleX : scaleY;
  return scale;
}

TEST_CASE ("ScaleToFit") {  ///
  ASSERT(FloatEquals(ScaleToFit({1, 1}, {2, 2}), 2));
  ASSERT(FloatEquals(ScaleToFit({1, 1}, {3, 2}), 2));
  ASSERT(FloatEquals(ScaleToFit({1, 1}, {2, 3}), 2));
  ASSERT(FloatEquals(ScaleToFit({3, 3}, {2, 3}), 2.0f / 3.0f));
}

constexpr f32 ScaleToCover(Vector2 inner, Vector2 container) {  ///
  f32 scaleX = container.x / inner.x;
  f32 scaleY = container.y / inner.y;
  f32 scale  = (scaleX > scaleY) ? scaleX : scaleY;
  return scale;
}

TEST_CASE ("ScaleToCover") {  ///
  ASSERT(FloatEquals(ScaleToCover({1, 1}, {2, 2}), 2));
  ASSERT(FloatEquals(ScaleToCover({1, 1}, {3, 2}), 3));
  ASSERT(FloatEquals(ScaleToCover({1, 1}, {2, 3}), 3));
  ASSERT(FloatEquals(ScaleToCover({3, 3}, {2, 3}), 1));
}

// ███╗   ███╗███████╗███╗   ███╗ ██████╗ ██████╗ ██╗   ██╗
// ████╗ ████║██╔════╝████╗ ████║██╔═══██╗██╔══██╗╚██╗ ██╔╝
// ██╔████╔██║█████╗  ██╔████╔██║██║   ██║██████╔╝ ╚████╔╝
// ██║╚██╔╝██║██╔══╝  ██║╚██╔╝██║██║   ██║██╔══██╗  ╚██╔╝
// ██║ ╚═╝ ██║███████╗██║ ╚═╝ ██║╚██████╔╝██║  ██║   ██║
// ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝

// Unmapping allocator.
// ------------------------------------------------------------
#if BF_DEBUG && defined(SDL_PLATFORM_WINDOWS)

#  include <windows.h>
#  include <stdio.h>

struct UnmappedAllocation {  ///
  void* result = {};
  void* base   = {};
};

static struct {  ///
  std::vector<UnmappedAllocation> allocs   = {};
  size_t                          pageSize = {};
} g_unmappingAllocatorData;

void* unmapped_alloc(size_t size) {  ///
  auto& data = g_unmappingAllocatorData;

  static bool initialized = false;
  if (!initialized) {
    initialized = true;
    SYSTEM_INFO si{};
    GetSystemInfo(&si);
    data = {.pageSize = si.dwPageSize};
  }

  auto pages
    = CeilDivisionU64(size, data.pageSize) + 2 * UNMAPPING_ALLOCATOR_PAGES_MARGIN;
  auto base   = VirtualAlloc(nullptr, pages * data.pageSize, MEM_RESERVE, PAGE_NOACCESS);
  auto addr   = (void*)((u8*)base + UNMAPPING_ALLOCATOR_PAGES_MARGIN * data.pageSize);
  auto result = VirtualAlloc(addr, size, MEM_COMMIT, PAGE_READWRITE);

#  if UNMAPPING_ALLOCATOR_ERROR_ON_RIGHT
  auto baseOffset = (pages - UNMAPPING_ALLOCATOR_PAGES_MARGIN) * data.pageSize - size;
#  else
  auto baseOffset = data.pageSize * UNMAPPING_ALLOCATOR_PAGES_MARGIN;
#  endif

  auto r = (void*)((u8*)base + baseOffset);
  data.allocs.push_back({.result = r, .base = base});
  return r;
}

void unmapped_free(void* ptr) {  ///
  auto& data = g_unmappingAllocatorData;

  FOR_RANGE (int, i, data.allocs.size()) {
    auto& v = data.allocs[i];
    if (v.result == ptr) {
      VirtualFree((void*)v.base, 0, MEM_RELEASE);

      if (i != data.allocs.size() - 1)
        v = data.allocs[data.allocs.size() - 1];
      data.allocs.pop_back();

      return;
    }
  }
  INVALID_PATH;
}

TEST_CASE ("Unmapping allocator") {  ///
  auto base = (u8*)unmapped_alloc(sizeof(u8));
  base[0]   = 255;
  unmapped_free(base);
}

#else

BF_FORCE_INLINE void* unmapped_alloc(size_t size) {  ///
  return malloc(size);
}

BF_FORCE_INLINE void unmapped_free(void* ptr) {  ///
  free(ptr);
}

#endif

// Arena.
// ------------------------------------------------------------
struct Arena {  ///
  size_t used    = 0;
  size_t size    = 0;
  u8*    base    = nullptr;
  size_t maxUsed = 0;
};

Arena MakeArena(size_t size) {  ///
  return {.size = size, .base = (u8*)BF_ALLOC(size)};
}

void DeinitArena(Arena* arena) {  ///
  BF_FREE(arena->base);
  *arena = {};
}

#define ALLOCATE_FOR(arena, type) (type*)(Allocate_(arena, sizeof(type)))
#define ALLOCATE_ARRAY(arena, type, count) \
  (type*)(Allocate_(arena, sizeof(type) * (count)))

#define ALLOCATE_ZEROS_FOR(arena, type) (type*)(AllocateZeros_(arena, sizeof(type)))
#define ALLOCATE_ZEROS_ARRAY(arena, type, count) \
  (type*)(AllocateZeros_(arena, sizeof(type) * (count)))

// NOLINTBEGIN(bugprone-macro-parentheses)
#define ALLOCATE_FOR_AND_INITIALIZE(arena, type)        \
  (INLINE_LAMBDA {                                      \
    auto ptr = (type*)(Allocate_(arena, sizeof(type))); \
    std::construct_at(ptr);                             \
    return ptr;                                         \
  }())
// NOLINTEND(bugprone-macro-parentheses)

// NOLINTBEGIN(bugprone-macro-parentheses)
#define ALLOCATE_ARRAY_AND_INITIALIZE(arena, type, count)         \
  (INLINE_LAMBDA {                                                \
    auto ptr = (type*)(Allocate_(arena, sizeof(type) * (count))); \
    FOR_RANGE (int, i, (count)) {                                 \
      std::construct_at(ptr + i);                                 \
    }                                                             \
    return ptr;                                                   \
  }())
// NOLINTEND(bugprone-macro-parentheses)

#define DEALLOCATE_ARRAY(arena, type, count) Deallocate_(arena, sizeof(type) * (count))

//
// TODO: Introduce the notion of `alignment` here!
// NOTE: Refer to Casey's memory allocation functions
// https://youtu.be/MvDUe2evkHg?list=PLEMXAbCVnmY6Azbmzj3BiC3QRYHE9QoG7&t=2121
//
inline u8* Allocate_(Arena* arena, size_t size) {  ///
  ASSERT(size > 0);
  ASSERT(arena->size >= size);
  ASSERT(arena->used <= arena->size - size);

  u8* result = arena->base + arena->used;
  arena->used += size;
  arena->maxUsed = MAX(arena->used, arena->maxUsed);
  return result;
}

inline u8* AllocateZeros_(Arena* arena, size_t size) {  ///
  auto result = Allocate_(arena, size);
  memset(result, 0, size);
  return result;
}

inline void Deallocate_(Arena* arena, size_t size) {  ///
  ASSERT(size > 0);
  ASSERT(arena->used >= size);
  arena->used -= size;
}

// TEMP_USAGE используется для временного использования арены.
// При вызове TEMP_USAGE запоминается текущее количество занятого
// пространства арены, которое обратно устанавливается при выходе из scope.
//
// Пример использования:
//
//     size_t X = trash_arena->used;
//     {
//         TEMP_USAGE(trash_arena);
//         int* aboba = ALLOCATE_FOR(trash_arena, u32);
//         ASSERT(trash_arena->used == X + 4);
//     }
//     ASSERT(trash_arena->used == X);
//

#define TEMP_USAGE_WITH_COUNTER_(arena, counter)     \
  auto _arena##counter##Used_ = (arena)->used;       \
  DEFER {                                            \
    ASSERT((arena)->used >= _arena##counter##Used_); \
    (arena)->used = _arena##counter##Used_;          \
  };
#define TEMP_USAGE_(arena, counter) TEMP_USAGE_WITH_COUNTER_(arena, counter)
#define TEMP_USAGE(arena) TEMP_USAGE_(arena, __COUNTER__)

//  ██████╗ ██████╗ ███╗   ██╗████████╗ █████╗ ██╗███╗   ██╗███████╗██████╗ ███████╗
// ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██║████╗  ██║██╔════╝██╔══██╗██╔════╝
// ██║     ██║   ██║██╔██╗ ██║   ██║   ███████║██║██╔██╗ ██║█████╗  ██████╔╝███████╗
// ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗╚════██║
// ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║██║ ╚████║███████╗██║  ██║███████║
//  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚══════╝

void UnstableRemoveAt_(u8* base, size_t stride, const int i, int* count) {  ///
  ASSERT(i >= 0);
  ASSERT(i < *count);

  if (i != *count - 1)
    memcpy(base + stride * i, base + stride * (*count - 1), stride);

  (*count)--;
}

#define ARRAY_PUSH(array, arrayCount, arrayMaxCount, value) \
  STATEMENT({                                               \
    *((array) + (arrayCount)) = value;                      \
    (arrayCount)++;                                         \
    ASSERT((arrayCount) <= (arrayMaxCount));                \
  })

template <typename T>
T ARRAY_POP(T* array, auto* arrayCount) {  ///
  ASSERT(*arrayCount > 0);
  T result    = *(array + *arrayCount - 1);
  *arrayCount = *arrayCount - 1;
  return result;
}

#define ARRAY_REVERSE(array, count)     \
  STATEMENT({                           \
    ASSERT((count) >= 0);               \
    FOR_RANGE (int, l, (count) / 2) {   \
      auto r         = (count) - l - 1; \
      auto t         = *((array) + l);  \
      *((array) + l) = *((array) + r);  \
      *((array) + r) = t;               \
    }                                   \
  })

template <typename T>
int ArrayFind(const T* base, int count, const T& value) {  ///
  FOR_RANGE (int, i, count) {
    if (base[i] == value)
      return i;
  }
  return -1;
}

template <typename T>
int ArrayBinaryFind(const T* base, int count, const T& value) {  ///
#if BF_ENABLE_ASSERTS
  FOR_RANGE (int, i, count - 1) {
    // Checking that array is sorted.
    ASSERT(base[i] <= base[i + 1]);
  }
#endif

  int low  = 0;
  int high = count - 1;
  while (low <= high) {
    int mid = low + (high - low) / 2;

    if (base[mid] < value)
      low = mid + 1;
    else if (base[mid] == value)
      return mid;
    else
      high = mid - 1;
  }

  return -1;
}

template <typename T>
BF_FORCE_INLINE bool ArrayContains(const T* base, int count, const T& value) {  ///
  return ArrayFind(base, count, value) != -1;
}

TEST_CASE ("ArrayFind, ArrayContains") {  ///
  {
    int  values[] = {0, 1, 2, 3, 4, 5};
    auto c        = ARRAY_COUNT(values);
    ASSERT(ArrayFind(values, c, 5) == 5);
    ASSERT(ArrayContains(values, c, 5));
    ASSERT_FALSE(ArrayContains(values, c, 6));
  }
  {
    int  values[] = {1, 2, 3, 4, 5};
    auto c        = ARRAY_COUNT(values);
    ASSERT(ArrayFind(values, c, 5) == 4);
    ASSERT(ArrayContains(values, c, 5));
    ASSERT_FALSE(ArrayContains(values, c, 6));
  }
  {
    int  values[] = {1, 2, 3, 4, 5};
    auto c        = ARRAY_COUNT(values);
    ASSERT(ArrayFind(values, c, 6) == -1);
    ASSERT(ArrayContains(values, c, 5));
    ASSERT_FALSE(ArrayContains(values, c, 6));
  }
}

void ArraySort_(
  void*                               buffer,
  int                                 elementSize,
  int                                 n,
  std::invocable<void*, void*> auto&& cmp,
  std::invocable<int, int> auto&&     callback,
  void*                               swapBuf
) {  ///
  ASSERT(elementSize > 0);

  FOR_RANGE (int, i, n - 1) {
    auto swapped = false;

    FOR_RANGE (int, j, n - i - 1) {
      auto v1 = (u8*)buffer + (j + 0) * elementSize;
      auto v2 = (u8*)buffer + (j + 1) * elementSize;

      if (cmp((void*)v1, (void*)v2) == 1) {
        memcpy(swapBuf, v1, elementSize);
        memcpy(v1, v2, elementSize);
        memcpy(v2, swapBuf, elementSize);

        callback(j, j + 1);

        swapped = true;
      }
    }

    if (!swapped)
      break;
  }
}

#define ARRAY_SORT(ptr, n, cmp, callback)                                             \
  STATEMENT({                                                                         \
    u8 swapBuf[sizeof(*(ptr))];                                                       \
    ArraySort_((void*)(ptr), sizeof(*(ptr)), (n), (cmp), (callback), (void*)swapBuf); \
  })

int IntCmp(const int* v1, const int* v2) {  ///
  if (*v1 > *v2)
    return 1;
  if (*v1 < *v2)
    return -1;
  return 0;
}

template <typename T>
bool Contains(const std::vector<T>& v, T x) {  ///
  return std::find(v.begin(), v.end(), x) != v.end();
}

template <typename T>
struct View {
  int count = 0;
  T*  base  = nullptr;

  T& operator[](int index) const {  ///
    ASSERT(base != nullptr);
    ASSERT(index >= 0);
    ASSERT(index < count);
    return base[index];
  }

  void Init(int count_) {  ///
    ASSERT(count == 0);
    ASSERT(base == nullptr);

    count = count_;
    base  = (T*)BF_ALLOC(sizeof(T) * count);
  }

  void Deinit() {  ///
    if (base) {
      ASSERT(count > 0);
      BF_FREE(base);
      base = nullptr;
    }
    else {
      ASSERT(count == 0);
    }

    count = 0;
  }

  void Zeroify() {  ///
    ASSERT(base != nullptr);
    ASSERT(count > 0);
    memset(base, 0, sizeof(T) * count);
  }

  int IndexOf(const T& value) const {  ///
    FOR_RANGE (int, i, count) {
      auto& v = base[i];
      if (v == value)
        return i;
    }

    return -1;
  }

  bool Contains(const T& value) const {  ///
    return IndexOf(value) != -1;
  }

  void UnstableRemoveAt(const int i) {  ///
    UnstableRemoveAt_((u8*)base, sizeof(*base), i, &count);
  }

  T* begin() {  ///
    return base;
  }

  T* end() {  ///
    return base + count;
  }
};

#define VIEW_FROM_ARRAY_DANGER(name)                          \
  View<std::remove_reference_t<decltype(*(name##_))>>(name) { \
    .count = ARRAY_COUNT(name##_), .base = (name##_),         \
  }

template <typename T, int _count>
struct Array {
  T                base[_count] = {};
  static const int count        = _count;

  T& operator[](int index) {  ///
    ASSERT(index >= 0);
    ASSERT(index < _count);
    return base[index];
  }

  const T& operator[](int index) const {  ///
    ASSERT(index >= 0);
    ASSERT(index < _count);
    return base[index];
  }

  void Zeroify() {  ///
    ASSERT(_count > 0);
    memset(base, 0, sizeof(T) * _count);
  }

  int IndexOf(const T& value) const {  ///
    FOR_RANGE (int, i, _count) {
      auto& v = base[i];
      if (v == value)
        return i;
    }

    return -1;
  }

  bool Contains(const T& value) const {  ///
    return IndexOf(value) != -1;
  }

  T* begin() {  ///
    return base;
  }

  T* end() {  ///
    return base + _count;
  }

  View<T> ToView() const {  ///
    return {
      .count = _count,
      .base  = (T*)base,
    };
  }
};

TEST_CASE ("UnstableRemoveAt_") {  ///
  int values[]{0, 1, 2, 3};
  int valuesCount = ARRAY_COUNT(values);
  UnstableRemoveAt_((u8*)values, sizeof(*values), 2, &valuesCount);
  ASSERT(valuesCount == 3);
  ASSERT(values[0] == 0);
  ASSERT(values[1] == 1);
  ASSERT(values[2] == 3);
  UnstableRemoveAt_((u8*)values, sizeof(*values), 0, &valuesCount);
  ASSERT(valuesCount == 2);
  ASSERT(values[0] == 3);
  ASSERT(values[1] == 1);
}

template <typename T>
struct Vector {
  T*  base     = nullptr;
  int count    = 0;
  u32 maxCount = 0;

  T& operator[](int index) {  ///
    ASSERT(base != nullptr);
    ASSERT(index >= 0);
    ASSERT(index < count);
    return base[index];
  }

  const T& operator[](int index) const {  ///
    ASSERT(base != nullptr);
    ASSERT(index >= 0);
    ASSERT(index < count);
    return base[index];
  }

  int IndexOf(const T& value) const {  ///
    FOR_RANGE (int, i, count) {
      auto& v = *(base + i);
      if (v == value)
        return i;
    }

    return -1;
  }

  bool Contains(const T& value) const {  ///
    return IndexOf(value) != -1;
  }

  T* Add() {  ///
    if (base == nullptr) {
      ASSERT(maxCount == 0);
      ASSERT(count == 0);

      maxCount = 8;
      base     = (T*)BF_ALLOC(sizeof(T) * maxCount);
    }
    else if (maxCount == count) {
      u32 newMaxCount = maxCount * 2;
      ASSERT(maxCount < newMaxCount);  // NOTE: Ловим overflow

      auto oldSize = sizeof(T) * maxCount;
      auto oldPtr  = base;

      base = (T*)BF_ALLOC(oldSize * 2);
      memcpy((void*)base, (void*)oldPtr, oldSize);
      BF_FREE(oldPtr);

      maxCount = newMaxCount;
    }

    auto result = base + count;
    count += 1;

    return result;
  }

  void RemoveAt(const int i) {  ///
    ASSERT(i >= 0);
    ASSERT(i < count);

    auto moveFromRightCount = count - i - 1;
    ASSERT(moveFromRightCount >= 0);

    if (moveFromRightCount > 0) {
      memmove((void*)(base + i), (void*)(base + i + 1), sizeof(T) * moveFromRightCount);
    }

    count--;
  }

  void UnstableRemoveAt(const int i) {  ///
    UnstableRemoveAt_((u8*)base, sizeof(*base), i, &count);
  }

  // Remove value + ensure there's no of the same value remaining.
  void UnstableRemoveUniqueAssert(T value) {  ///
#if BF_ENABLE_ASSERTS
    int found = 0;
    for (auto& v : *this) {
      if (v == value)
        found++;
    }
    ASSERT(found == 1);
#endif

    int i = 0;
    for (auto& v : *this) {
      if (v == value) {
        UnstableRemoveAt(i);
        break;
      }
      i++;
    }
  }

  // Вектор сможет содержать как минимум столько элементов без реаллокации.
  void Reserve(u32 elementsCount) {  ///
    if (base == nullptr) {
      base     = (T*)BF_ALLOC(sizeof(T) * elementsCount);
      maxCount = elementsCount;
      return;
    }

    if (maxCount < elementsCount) {
      // TODO: Implement + use BF_REALLOC?
      auto oldBase = base;
      base         = (T*)BF_ALLOC(sizeof(T) * elementsCount);
      memcpy(base, oldBase, sizeof(T) * maxCount);
      BF_FREE(oldBase);
      maxCount = elementsCount;
    }
  }

  void Reset() {  ///
    count = 0;
  }

  void Deinit() {  ///
    if (base) {
      ASSERT(maxCount > 0);
      BF_FREE(base);
      base = nullptr;
    }
    else {
      ASSERT(maxCount == 0);
      ASSERT(count == 0);
    }

    count    = 0;
    maxCount = 0;
  }

  T* begin() {  ///
    return base;
  }

  T* end() {  ///
    return base + count;
  }
};

template <typename T>
struct VectorIterator : public IteratorFacade<VectorIterator<T>> {  ///
  VectorIterator() = delete;
  explicit VectorIterator(Vector<T>* container)
      : VectorIterator(container, 0) {}
  VectorIterator(Vector<T>* container, int current)
      : _container(container)
      , _current(current)  //
  {
    ASSERT(container != nullptr);
  }

  [[nodiscard]] VectorIterator begin() const {
    return {_container, _current};
  }

  [[nodiscard]] VectorIterator end() const {
    return {_container, _container->count};
  }

  [[nodiscard]] T* Dereference() const {
    ASSERT(_current >= 0);
    ASSERT(_current < _container->count);
    return _container->base + _current;
  }

  void Increment() {
    _current++;
  }

  [[nodiscard]] bool EqualTo(const VectorIterator& o) const {
    return _current == o._current;
  }

  private:
  Vector<T>* _container;
  int        _current = 0;
};

template <typename T>
auto Iter(Vector<T>* container) {  ///
  return VectorIterator(container);
}

struct RangeIterator : public IteratorFacade<RangeIterator> {  ///
  RangeIterator() = delete;
  explicit RangeIterator(int end)
      : RangeIterator(0, end) {}
  RangeIterator(int current, int end)
      : _current(current)
      , _end(end) {
    ASSERT(current <= end);
  }

  [[nodiscard]] RangeIterator begin() const {
    return {_current, _end};
  }

  [[nodiscard]] RangeIterator end() const {
    return {_end, _end};
  }

  [[nodiscard]] int Dereference() const {
    ASSERT(_current >= 0);
    ASSERT(_current < _end);
    return _current;
  }

  void Increment() {
    _current++;
  }

  [[nodiscard]] bool EqualTo(const RangeIterator& o) const {
    return _current == o._current;
  }

  private:
  int _current = {};
  int _end     = {};
};

#if defined(SDL_PLATFORM_EMSCRIPTEN)

template <typename T>
struct ReaderWriterQueue {  ///
  Vector<T> _values = {};

  void enqueue(T value) {
    *_values.Add() = value;
  }

  bool try_dequeue(T& out) {
    if (_values.count) {
      out = _values[_values.count - 1];
      _values.count--;
      return true;
    }
    return false;
  }
};

#else

#  include "readerwriterqueue.h"
using moodycamel::ReaderWriterQueue;

#endif

// ██████╗  █████╗ ███╗   ██╗██████╗  ██████╗ ███╗   ███╗
// ██╔══██╗██╔══██╗████╗  ██║██╔══██╗██╔═══██╗████╗ ████║
// ██████╔╝███████║██╔██╗ ██║██║  ██║██║   ██║██╔████╔██║
// ██╔══██╗██╔══██║██║╚██╗██║██║  ██║██║   ██║██║╚██╔╝██║
// ██║  ██║██║  ██║██║ ╚████║██████╔╝╚██████╔╝██║ ╚═╝ ██║
// ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝ ╚═╝     ╚═╝

struct Random {
  bool _raise = false;
  u32  _state = {};

  explicit Random(u32 seed)
      : _state(seed) {}

  // Based off splitMix32.
  u32 Rand() {  ///
    ASSERT_FALSE(_raise);

    u32 z = _state + 0x9e3779b9;
    z ^= z >> 15;
    z *= 0x85ebca6b;
    z ^= z >> 13;
    z *= 0xc2b2ae35;
    _state     = z;  // NOTE: Added by me. Should i just increment _state?
    u32 result = z ^ (z >> 16);
    return result;
  }

  // [0; 1)
  f32 FRand() {  ///
    return (f32)((f64)Rand() / (f64)((u64)u32_max + 1));
  }

  // [-1; 1)
  f32 FRand11() {  ///
    return FRand() * 2 - 1;
  }

  // [0; 2 * PI32)
  f32 Angle() {  ///
    return FRand() * 2 * PI32;
  }

  // [a; b]
  int RandInt(int a, int b) {  ///
    ASSERT(a <= b);
    auto r = (int)(FRand() * (f32)(b - a + 1));
    ASSERT(r >= 0);
    return a + r;
  }

  int RandInt(uint a, uint b) {  ///
    ASSERT(a <= b);
    int r = (int)(FRand() * (f32)(b - a + 1));
    ASSERT(r >= 0);
    return (int)a + r;
  }

  int RandInt(int b) {  ///
    return MIN((int)(FRand() * b), b);
  }

  int RandInt(uint b) {  ///
    auto r = FRand() * (f32)b;
    ASSERT(r >= 0);
    return MIN((int)r, (int)b);
  }

  template <typename T>
  void Shuffle(T* array, size_t n) {  ///
    if (n > 1) {
      for (size_t i = n - 1; i > 0; i--) {
        size_t j = Rand() % (i + 1);

        T temp   = array[i];
        array[i] = array[j];
        array[j] = temp;
      }
    }
  }
};

TEST_CASE ("FRand") {  ///
  Random r{0};

  FOR_RANGE (int, i, 1000) {
    auto result = r.FRand();
    ASSERT(result >= 0);
    ASSERT(result < 1);
  }
}

TEST_CASE ("RandInt") {  ///
  int values_[1000];
  VIEW_FROM_ARRAY_DANGER(values);

  Random r{0};

  FOR_RANGE (int, i, values.count) {
    auto result = r.RandInt(10, 20);
    ASSERT(result >= 10);
    ASSERT(result <= 20);
    values[i] = result;
  }

  ASSERT(values.Contains(10));
  ASSERT(values.Contains(20));

  ASSERT(r.RandInt(1, 1) == 1);
}

TEST_CASE ("RandInt") {  ///
  Random r{0};

  FOR_RANGE (int, i, 1000) {
    ASSERT(r.RandInt(1) <= 1);
  }
}

TEST_CASE ("Shuffle") {  ///
  int values_[]{0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  VIEW_FROM_ARRAY_DANGER(values);

  Random r{0};
  r.Shuffle(values.base, values.count);

  FOR_RANGE (int, i, values.count) {
    ASSERT(values.Contains(i));
  }
}

/*
struct PerlinParams {  ///
  int octaves    = {};
  f32 smoothness = {};
};

void CycledPerlin2D(
  View<u16>    output,
  Arena*       trashArena,
  PerlinParams params,
  Vector2Int   size
) {  ///
  ASSERT(output.count == size.x * size.y);

  int sxPower = 0;
  int syPower = 0;

  ASSERT(size.x > 0);
  ASSERT(size.y > 0);
  {
    auto sxIs = IsPowerOf2(size.x, &sxPower);
    auto syIs = IsPowerOf2(size.y, &syPower);
    ASSERT(sxIs);
    ASSERT(syIs);
  }

  ASSERT(params.octaves > 0);
  ASSERT(params.smoothness > 0);

  TEMP_USAGE(trashArena);

  auto octaves = params.octaves;

  auto totalPixels = (u32)(size.x * size.y);
  auto cover       = ALLOCATE_ARRAY(trashArena, f32, totalPixels);
  auto accumulator = ALLOCATE_ARRAY(trashArena, f32, totalPixels);

  FOR_RANGE (u64, i, (u64)totalPixels) {
    *(cover + i)       = FRand();
    *(accumulator + i) = 0;
  }

  f32 sumOfDivision = 0;
  octaves           = MIN(sxPower, octaves);

  int offset = size.x;

  f32 octaveC = 1.0f;
  FOR_RANGE (int, _, octaves) {
    sumOfDivision += octaveC;

    int x0Index = 0;
    int x1Index = offset % size.x;
    int y0Index = 0;
    int y1Index = offset % size.y;

    int yit = 0;
    int xit = 0;
    FOR_RANGE (int, y, size.y) {
      int y0s = size.y * y0Index;
      int y1s = size.y * y1Index;

      FOR_RANGE (int, x, size.x) {
        if (xit == offset) {
          x0Index = x1Index;
          x1Index = (x1Index + offset) % size.x;
          xit     = 0;
        }

        auto a0 = *(cover + y0s + x0Index);
        auto a1 = *(cover + y0s + x1Index);
        auto a2 = *(cover + y1s + x0Index);
        auto a3 = *(cover + y1s + x1Index);

        auto xb      = (f32)xit / (f32)offset;
        auto yb      = (f32)yit / (f32)offset;
        auto blend01 = Lerp(a0, a1, xb);
        auto blend23 = Lerp(a2, a3, xb);
        auto value   = octaveC * Lerp(blend01, blend23, yb);

        *(accumulator + size.x * y + x) += value;
        xit++;
      }

      yit++;
      if (yit == offset) {
        y0Index = y1Index;
        y1Index = (y1Index + offset) % size.y;
        yit     = 0;
      }
    }

    offset >>= 1;
    octaveC /= params.smoothness;
  }

  FOR_RANGE (int, y, size.y) {
    FOR_RANGE (int, x, size.x) {
      f32 t = *(accumulator + y * size.y + x) / sumOfDivision;
      ASSERT(t >= 0);
      ASSERT(t <= 1.0f);

      u16 value = (u16)((f32)u16_max * t);

      output[y * size.x + x] = value;
    }
  }
}
*/

//  ██████╗ ██████╗ ██╗      ██████╗ ██████╗ ███████╗
// ██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗██╔════╝
// ██║     ██║   ██║██║     ██║   ██║██████╔╝███████╗
// ██║     ██║   ██║██║     ██║   ██║██╔══██╗╚════██║
// ╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║███████║
//  ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

struct Color {  ///
  u8 r = u8_max;
  u8 g = u8_max;
  u8 b = u8_max;
  u8 a = u8_max;

  Color operator*(const Color& v) {
    Color result{
      (u8)(v.r * r / 255),
      (u8)(v.g * g / 255),
      (u8)(v.b * b / 255),
      (u8)(v.a * a / 255),
    };
    return result;
  }

  bool operator==(const Color& other) const {
    return (r == other.r)     //
           && (g == other.g)  //
           && (b == other.b)  //
           && (a == other.a);
  }
};

constexpr Color ColorFromRGB(u32 color) {  ///
  Color color_{
    .r = (u8)((color & (0xff << 16)) >> 16),
    .g = (u8)((color & (0xff << 8)) >> 8),
    .b = (u8)((color & (0xff << 0)) >> 0),
    .a = 255,
  };
  return color_;
}

TEST_CASE ("ColorFromRGB") {  ///
  auto c = ColorFromRGB(0xff0001);
  ASSERT(c.r == 255);
  ASSERT(c.g == 0);
  ASSERT(c.b == 1);
  ASSERT(c.a == 255);
}

constexpr Color ColorFromRGBA(u32 color) {  ///
  return {
    .r = (u8)((color >> 24) & 255),
    .g = (u8)((color >> 16) & 255),
    .b = (u8)((color >> 8) & 255),
    .a = (u8)((color >> 0) & 255),
  };
}

TEST_CASE ("ColorFromRGBA") {  ///
  auto c = ColorFromRGBA(0xff000102);
  ASSERT(c.r == 255);
  ASSERT(c.g == 0);
  ASSERT(c.b == 1);
  ASSERT(c.a == 2);
}

u32 ColorToRGBA(Color color) {  ///
  u32 value = 0;
  value += (u32)color.r << 24;
  value += (u32)color.g << 16;
  value += (u32)color.b << 8;
  value += (u32)color.a << 0;
  return value;
}

Color ColorFromABGR(u32 color) {  ///
  return *(Color*)&color;
}

TEST_CASE ("ColorFromABGR") {  ///
  auto c = ColorFromABGR(0xff000102);
  ASSERT(c.r == 2);
  ASSERT(c.g == 1);
  ASSERT(c.b == 0);
  ASSERT(c.a == 255);
}

u32 ColorToABGR(Color color) {  ///
  return *(u32*)&color;
}

constexpr Color TRANSPARENT_BLACK = {0, 0, 0, 0};
constexpr Color TRANSPARENT_WHITE = {u8_max, u8_max, u8_max, 0};
constexpr Color WHITE             = {};
constexpr Color BLACK             = {0, 0, 0, u8_max};
constexpr Color GRAY              = {u8_max / 2, u8_max / 2, u8_max / 2, u8_max};
constexpr Color RED               = {u8_max, 0, 0, u8_max};
constexpr Color GREEN             = {0, u8_max, 0, u8_max};
constexpr Color BLUE              = {0, 0, u8_max, u8_max};
constexpr Color YELLOW            = {u8_max, u8_max, 0, u8_max};
constexpr Color CYAN              = {0, u8_max, u8_max, u8_max};
constexpr Color MAGENTA           = {u8_max, 0, u8_max, u8_max};

Color Darken(Color value, f32 p) {  ///
  ASSERT(p >= 0);
  ASSERT(p <= 1);
  return {
    .r = (u8)((f32)value.g * p),
    .g = (u8)((f32)value.g * p),
    .b = (u8)((f32)value.b * p),
    .a = value.a,
  };
}

Color Fade(Color value, f32 p) {  ///
  ASSERT(p >= 0);
  ASSERT(p <= 1);
  value.a = (u8)(255 * Clamp01(p));
  return value;
}

Color ColorLerp(Color v1, Color v2, f32 p) {  ///
  ASSERT(p >= 0);
  ASSERT(p <= 1);

  Color result{
    (u8)MIN(255.0f, MAX(0.0f, (f32)v1.r * (1.0f - p) + (f32)v2.r * p)),
    (u8)MIN(255.0f, MAX(0.0f, (f32)v1.g * (1.0f - p) + (f32)v2.g * p)),
    (u8)MIN(255.0f, MAX(0.0f, (f32)v1.b * (1.0f - p) + (f32)v2.b * p)),
    (u8)MIN(255.0f, MAX(0.0f, (f32)v1.a * (1.0f - p) + (f32)v2.a * p)),
  };
  return result;
}

constexpr bool ColorIsEqual(Color col1, Color col2) {  ///
  bool result = false;

  if ((col1.r == col2.r)     //
      && (col1.g == col2.g)  //
      && (col1.b == col2.b)  //
      && (col1.a == col2.a))
    result = true;

  return result;
}

constexpr int ColorToHex(Color color) {  ///
  int result = 0;

  result = (int)(((unsigned int)color.r << 24)    //
                 | ((unsigned int)color.g << 16)  //
                 | ((unsigned int)color.b << 8)   //
                 | (unsigned int)color.a);

  return result;
}

// Get color normalized as f32 [0..1]
constexpr Vector4 ColorNormalize(Color color) {  ///
  Vector4 result;

  result.x = (f32)color.r / 255.0f;
  result.y = (f32)color.g / 255.0f;
  result.z = (f32)color.b / 255.0f;
  result.w = (f32)color.a / 255.0f;

  return result;
}

// Get color from normalized values [0..1]
constexpr Color ColorFromNormalized(Vector4 normalized) {  ///
  Color result;

  result.r = (unsigned char)(normalized.x * 255.0f);
  result.g = (unsigned char)(normalized.y * 255.0f);
  result.b = (unsigned char)(normalized.z * 255.0f);
  result.a = (unsigned char)(normalized.w * 255.0f);

  return result;
}

// Get HSV values for a Color
// NOTE: Hue is returned as degrees [0..360]
constexpr Vector3 ColorToHSV(Color color) {  ///
  Vector3 hsv{};
  Vector3 rgb = {(f32)color.r / 255.0f, (f32)color.g / 255.0f, (f32)color.b / 255.0f};
  f32     min, max, delta;

  min = rgb.x < rgb.y ? rgb.x : rgb.y;
  min = min < rgb.z ? min : rgb.z;

  max = rgb.x > rgb.y ? rgb.x : rgb.y;
  max = max > rgb.z ? max : rgb.z;

  hsv.z = max;  // Value
  delta = max - min;

  if (delta < 0.00001f) {
    hsv.y = 0.0f;
    hsv.x = 0.0f;  // Undefined, maybe NAN?
    return hsv;
  }

  if (max > 0.0f) {
    // NOTE: If max is 0, this divide would cause a crash
    hsv.y = (delta / max);  // Saturation
  }
  else {
    // NOTE: If max is 0, then r = g = b = 0, s = 0, h is undefined
    hsv.y = 0.0f;
    hsv.x = NAN;  // Undefined
    return hsv;
  }

  // NOTE: Comparing f32 values could not work properly
  if (rgb.x >= max)
    hsv.x = (rgb.y - rgb.z) / delta;  // Between yellow & magenta
  else {
    if (rgb.y >= max)
      hsv.x = 2.0f + (rgb.z - rgb.x) / delta;  // Between cyan & yellow
    else
      hsv.x = 4.0f + (rgb.x - rgb.y) / delta;  // Between magenta & cyan
  }

  hsv.x *= 60.0f;  // Convert to degrees

  if (hsv.x < 0.0f)
    hsv.x += 360.0f;

  return hsv;
}

// Get a Color from HSV values
// Implementation reference:
// https://en.wikipedia.org/wiki/HSL_and_HSV#Alternative_HSV_conversion NOTE:
// Color->HSV->Color conversion will not yield exactly the same color due to rounding
// errors Hue is provided in degrees: [0..360] Saturation/Value are provided normalized:
// [0.0f..1.0f]
Color ColorFromHSV(f32 hue, f32 saturation, f32 value) {  ///
  Color color{0, 0, 0, 255};

  // Red channel
  f32 k   = fmodf((5.0f + hue / 60.0f), 6);
  f32 t   = 4.0f - k;
  k       = (t < k) ? t : k;
  k       = (k < 1) ? k : 1;
  k       = (k > 0) ? k : 0;
  color.r = (unsigned char)((value - value * saturation * k) * 255.0f);

  // Green channel
  k       = fmodf((3.0f + hue / 60.0f), 6);
  t       = 4.0f - k;
  k       = (t < k) ? t : k;
  k       = (k < 1) ? k : 1;
  k       = (k > 0) ? k : 0;
  color.g = (unsigned char)((value - value * saturation * k) * 255.0f);

  // Blue channel
  k       = fmodf((1.0f + hue / 60.0f), 6);
  t       = 4.0f - k;
  k       = (t < k) ? t : k;
  k       = (k < 1) ? k : 1;
  k       = (k > 0) ? k : 0;
  color.b = (unsigned char)((value - value * saturation * k) * 255.0f);

  return color;
}

// Get color multiplied with another color
constexpr Color ColorTint(Color color, Color tint) {  ///
  Color result = color;

  unsigned char r = (unsigned char)(((int)color.r * (int)tint.r) / 255);
  unsigned char g = (unsigned char)(((int)color.g * (int)tint.g) / 255);
  unsigned char b = (unsigned char)(((int)color.b * (int)tint.b) / 255);
  unsigned char a = (unsigned char)(((int)color.a * (int)tint.a) / 255);

  result.r = r;
  result.g = g;
  result.b = b;
  result.a = a;

  return result;
}

// Get color with brightness correction, brightness factor goes from -1.0f to 1.0f
constexpr Color ColorBrightness(Color color, f32 factor) {  ///
  Color result = color;

  if (factor > 1.0f)
    factor = 1.0f;
  else if (factor < -1.0f)
    factor = -1.0f;

  f32 red   = (f32)color.r;
  f32 green = (f32)color.g;
  f32 blue  = (f32)color.b;

  if (factor < 0.0f) {
    factor = 1.0f + factor;
    red *= factor;
    green *= factor;
    blue *= factor;
  }
  else {
    red   = (255 - red) * factor + red;
    green = (255 - green) * factor + green;
    blue  = (255 - blue) * factor + blue;
  }

  result.r = (unsigned char)red;
  result.g = (unsigned char)green;
  result.b = (unsigned char)blue;

  return result;
}

// Get color with contrast correction
// NOTE: Contrast values between -1.0f and 1.0f
constexpr Color ColorContrast(Color color, f32 contrast) {  ///
  Color result = color;

  if (contrast < -1.0f)
    contrast = -1.0f;
  else if (contrast > 1.0f)
    contrast = 1.0f;

  contrast = (1.0f + contrast);
  contrast *= contrast;

  f32 pR = (f32)color.r / 255.0f;
  pR -= 0.5f;
  pR *= contrast;
  pR += 0.5f;
  pR *= 255;
  if (pR < 0)
    pR = 0;
  else if (pR > 255)
    pR = 255;

  f32 pG = (f32)color.g / 255.0f;
  pG -= 0.5f;
  pG *= contrast;
  pG += 0.5f;
  pG *= 255;
  if (pG < 0)
    pG = 0;
  else if (pG > 255)
    pG = 255;

  f32 pB = (f32)color.b / 255.0f;
  pB -= 0.5f;
  pB *= contrast;
  pB += 0.5f;
  pB *= 255;
  if (pB < 0)
    pB = 0;
  else if (pB > 255)
    pB = 255;

  result.r = (unsigned char)pR;
  result.g = (unsigned char)pG;
  result.b = (unsigned char)pB;

  return result;
}

// Get color with alpha applied, alpha goes from 0.0f to 1.0f
Color ColorAlpha(Color color, f32 alpha) {  ///
  Color result = color;

  if (alpha < 0.0f)
    alpha = 0.0f;
  else if (alpha > 1.0f)
    alpha = 1.0f;

  result.a = (unsigned char)(255.0f * alpha);

  return result;
}

// Get src alpha-blended into dst color with tint
Color ColorAlphaBlend(Color dst, Color src, Color tint) {  ///
  Color out = WHITE;

  // Apply color tint to source color
  src.r = (unsigned char)(((unsigned int)src.r * ((unsigned int)tint.r + 1)) >> 8);
  src.g = (unsigned char)(((unsigned int)src.g * ((unsigned int)tint.g + 1)) >> 8);
  src.b = (unsigned char)(((unsigned int)src.b * ((unsigned int)tint.b + 1)) >> 8);
  src.a = (unsigned char)(((unsigned int)src.a * ((unsigned int)tint.a + 1)) >> 8);

// #define COLORALPHABLEND_FLOAT
#define COLORALPHABLEND_INTEGERS
#if defined(COLORALPHABLEND_INTEGERS)
  if (src.a == 0)
    out = dst;
  else if (src.a == 255)
    out = src;
  else {
    unsigned int alpha
      = (unsigned int)src.a + 1;  // We are shifting by 8 (dividing by 256), so we need to
                                  // take that excess into account
    out.a
      = (unsigned char)(((unsigned int)alpha * 256 + (unsigned int)dst.a * (256 - alpha))
                        >> 8);

    if (out.a > 0) {
      out.r
        = (unsigned char)((((unsigned int)src.r * alpha * 256
                            + (unsigned int)dst.r * (unsigned int)dst.a * (256 - alpha))
                           / out.a)
                          >> 8);
      out.g
        = (unsigned char)((((unsigned int)src.g * alpha * 256
                            + (unsigned int)dst.g * (unsigned int)dst.a * (256 - alpha))
                           / out.a)
                          >> 8);
      out.b
        = (unsigned char)((((unsigned int)src.b * alpha * 256
                            + (unsigned int)dst.b * (unsigned int)dst.a * (256 - alpha))
                           / out.a)
                          >> 8);
    }
  }
#endif
#if defined(COLORALPHABLEND_FLOAT)
  if (src.a == 0)
    out = dst;
  else if (src.a == 255)
    out = src;
  else {
    Vector4 fdst  = ColorNormalize(dst);
    Vector4 fsrc  = ColorNormalize(src);
    Vector4 ftint = ColorNormalize(tint);
    Vector4 fout  = {0};

    fout.w = fsrc.w + fdst.w * (1.0f - fsrc.w);

    if (fout.w > 0.0f) {
      fout.x = (fsrc.x * fsrc.w + fdst.x * fdst.w * (1 - fsrc.w)) / fout.w;
      fout.y = (fsrc.y * fsrc.w + fdst.y * fdst.w * (1 - fsrc.w)) / fout.w;
      fout.z = (fsrc.z * fsrc.w + fdst.z * fdst.w * (1 - fsrc.w)) / fout.w;
    }

    out = (Color
    ){(unsigned char)(fout.x * 255.0f),
      (unsigned char)(fout.y * 255.0f),
      (unsigned char)(fout.z * 255.0f),
      (unsigned char)(fout.w * 255.0f)};
  }
#endif

  return out;
}

//  █████╗ ██╗   ██╗██████╗ ██╗ ██████╗
// ██╔══██╗██║   ██║██╔══██╗██║██╔═══██╗
// ███████║██║   ██║██║  ██║██║██║   ██║
// ██╔══██║██║   ██║██║  ██║██║██║   ██║
// ██║  ██║╚██████╔╝██████╔╝██║╚██████╔╝
// ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝

// https://www.w3.org/TR/audio-eq-cookbook/

// Biquads.
// ------------------------------------------------------------
// https://www.earlevel.com/main/2021/09/02/biquad-calculator-v3/
// ^ Max frequency - 22049 Hz
// ^ Min frequency - 1 Hz
// ^ Default Q - 0.7071

struct Biquad {  ///
  f32 b0, b1, b2, a0, a1, a2 = {};
};

Biquad BiquadLowpass(int sampleRate, f32 freq, f32 q) {  ///
  const f32 w    = 2 * PI32 * freq / (f32)sampleRate;
  const f32 a    = sinf(w) / 2 / q;
  const f32 cosw = cosf(w);

  return {
    .b0 = (1 - cosw) / 2,
    .b1 = 1 - cosw,
    .b2 = (1 - cosw) / 2,
    .a0 = 1 + a,
    .a1 = -2 * cosw,
    .a2 = 1 - a,
  };
}

// ██╗   ██╗████████╗██╗██╗     ███████╗
// ██║   ██║╚══██╔══╝██║██║     ██╔════╝
// ██║   ██║   ██║   ██║██║     ███████╗
// ██║   ██║   ██║   ██║██║     ╚════██║
// ╚██████╔╝   ██║   ██║███████╗███████║
//  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚══════╝

char* TextFormat(const char* text, ...) {  ///
  // Maximum number of static buffers for text formatting.
#ifndef MAX_TEXTFORMAT_BUFFERS
#  define MAX_TEXTFORMAT_BUFFERS 4
#endif

// Maximum size of static text buffer.
#ifndef MAX_TEXT_BUFFER_LENGTH
#  define MAX_TEXT_BUFFER_LENGTH 1024
#endif

  // We create an array of buffers so strings
  // don't expire until MAX_TEXTFORMAT_BUFFERS invocations.
  static char buffers[MAX_TEXTFORMAT_BUFFERS][MAX_TEXT_BUFFER_LENGTH] = {0};
  static int  index                                                   = 0;

  char* currentBuffer = buffers[index];
  memset(currentBuffer, 0, MAX_TEXT_BUFFER_LENGTH);  // Clear buffer before using.

  va_list args;
  va_start(args, text);
  int requiredByteCount = vsnprintf(currentBuffer, MAX_TEXT_BUFFER_LENGTH, text, args);
  va_end(args);

  // If requiredByteCount is larger than the MAX_TEXT_BUFFER_LENGTH, then overflow occured
  if (requiredByteCount >= MAX_TEXT_BUFFER_LENGTH) {
    // Inserting "..." at the end of the string to mark as truncated
    char* truncBuffer
      = buffers[index] + MAX_TEXT_BUFFER_LENGTH - 4;  // Adding 4 bytes = "...\0"

    sprintf(truncBuffer, "...");  // NOLINT
  }

  index += 1;  // Move to next buffer for next function call
  if (index >= MAX_TEXTFORMAT_BUFFERS)
    index = 0;

  return currentBuffer;
}

char* TextStrip(char* s, size_t* len) {  ///
  while ((*s == ' ') || (*s == '\t'))
    s++;

  auto l     = strlen(s);
  auto prevL = l;
  if (*s != 0) {
    auto c = s + l - 1;
    while ((s < c) && ((*c == ' ') || (*c == '\t'))) {
      *c = 0;
      c--;
      l--;
    }
  }
  ASSERT(prevL >= l);
  if (len)
    *len = l;
  return s;
}

TEST_CASE ("TextStrip") {  ///
  {
    char   s[]{' ', 'a', 'b', 'c', 'd', ' ', ' ', '\0'};
    size_t l{};
    auto   ss = TextStrip(s, &l);
    ASSERT(ss - s == 1);
    ASSERT(l == 4);
  }

  {
    char   s[]{'a', 'b', 'c', 'd', ' ', ' ', '\0'};
    size_t l{};
    auto   ss = TextStrip(s, &l);
    ASSERT(ss - s == 0);
    ASSERT(l == 4);
  }

  {
    char   s[]{' ', 'a', 'b', 'c', 'd', '\0'};
    size_t l{};
    auto   ss = TextStrip(s, &l);
    ASSERT(ss - s == 1);
    ASSERT(l == 4);
  }

  {
    char   s[]{'\0'};
    size_t l{};
    auto   ss = TextStrip(s, &l);
    ASSERT(ss - s == 0);
    ASSERT(l == 0);
  }

  {
    char   s[]{'a', '\0'};
    size_t l{};
    auto   ss = TextStrip(s, &l);
    ASSERT(ss - s == 0);
    ASSERT(l == 1);
  }
}

const char* TextHeapify(const char* value) {  ///
  auto l   = strlen(value);
  auto res = BF_ALLOC(l + 1);
  memcpy(res, value, l + 1);
  ASSERT_FALSE(((const char*)res)[l]);
  return (const char*)res;
}

char* StripLeadingZerosInFloat(char* string) {  ///
  const char* end = string;
  int         len = 0;
  while (*end) {
    end++;
    len++;
  }
  for (int i = len - 1; i >= 0; i--) {
    if (string[i] == '0')
      string[i] = '\0';
    else if (string[i] == '.') {
      string[i] = '\0';
      break;
    }
    else
      break;
  }
  return string;
}

TEST_CASE ("StripLeadingZerosInFloat") {  ///
  char buffer[]{'1', '.', '0', '\0'};
  ASSERT(strlen(buffer) == 3);
  StripLeadingZerosInFloat(buffer);
  ASSERT(strlen(buffer) == 1);
  StripLeadingZerosInFloat(buffer);
  ASSERT(strlen(buffer) == 1);
}

char* FormatInt(int v) {  ///
  return TextFormat("%d", v);
}

char* FormatSignedInt(int v) {  ///
  auto format = "%d";
  if (v >= 0)
    format = "+%d";
  return TextFormat(format, v);
}

char* FormatFloatDot1(f32 v) {  ///
  return TextFormat("%.1f", v);
}

char* FormatSignedFloatDot1(f32 v) {  ///
  auto format = "%.1f";
  if (v >= 0)
    format = "+%.1f";
  return TextFormat(format, v);
}

char* FormatFloatDot1WithoutLeadingZeros(f32 v) {  ///
  return StripLeadingZerosInFloat(FormatFloatDot1(v));
}

char* FormatSignedFloatDot1WithoutLeadingZeros(f32 v) {  ///
  return StripLeadingZerosInFloat(FormatSignedFloatDot1(v));
}

const char* PushTextToArena(Arena* arena, const char* text, int* outLen = nullptr) {  ///
  size_t len = strlen(text);
  auto   s   = ALLOCATE_ARRAY(arena, u8, len + 1);
  memcpy(s, text, len);
  s[len] = 0;
  if (outLen)
    *outLen = (int)len;
  return (const char*)s;
}

// clang-format off
static const u8 _utf8d[364] {  ///
	// The first part of the table maps bytes to character classes that
	// to reduce the size of the transition table and create bitmasks.
	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,  9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,
	 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,  7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
	 8,8,2,2,2,2,2,2,2,2,2,2,2,2,2,2,  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
	10,3,3,3,3,3,3,3,3,3,3,3,3,4,3,3, 11,6,6,6,5,8,8,8,8,8,8,8,8,8,8,8,

	// The second part is a transition table that maps a combination
	// of a state of the automaton and a character class to a state.
	 0,12,24,36,60,96,84,12,12,12,48,72, 12,12,12,12,12,12,12,12,12,12,12,12,
	12, 0,12,12,12,12,12, 0,12, 0,12,12, 12,24,12,12,12,12,12,24,12,24,12,12,
	12,12,12,12,12,12,12,24,12,12,12,12, 12,24,12,12,12,12,12,12,12,24,12,12,
	12,12,12,12,12,12,12,36,12,36,12,12, 12,36,12,12,12,12,12,36,12,36,12,12,
	12,36,12,12,12,12,12,12,12,12,12,12
};
// clang-format on

u32 _UTF8Decode(u32* state, u8 _ch, u32* _codep) {  ///
  u32 byte = _ch;
  u32 type = _utf8d[byte];
  *_codep  = (*state != 0) ? (byte & 0x3fu) | (*_codep << 6) : (0xff >> type) & (byte);
  *state   = _utf8d[256 + *state + type];
  return *state;
}

// NOTE: Be sure to handle `0` - the sentinel value.
// It's passed to inform that iteration is over.
BF_FORCE_INLINE void IterateOverCodepoints(
  const char*                                         text,
  int                                                 bytesCount,
  auto&& /* void(u32 codepoint, u32 codepointSize) */ lambda
) noexcept {  ///
  ASSERT(bytesCount > 0);
  ASSERT(text);

  u32  codepoint{};
  u32  codepointSize = 0;
  u32  state{};
  auto remaining = bytesCount + 1;

  auto p = text;
  for (; *p; ++p) {
    codepointSize++;
    remaining--;
    if (remaining <= 0)
      break;
    if (_UTF8Decode(&state, *(u8*)p, &codepoint))
      continue;

    lambda(codepoint, codepointSize);
    codepointSize = 0;
  }
  lambda(0, 0);
  ASSERT_FALSE(state);  // The string is not well-formed.
}

char* EncodeToHex(
  const u8* toEncodeLittleEndian,
  size_t    size,
  Arena*    arena,
  size_t*   len = nullptr
) {  ///
  ASSERT(toEncodeLittleEndian);
  ASSERT(size > 0);
  char* result = ALLOCATE_ARRAY(arena, char, size * 2 + 1);

  for (size_t i = 0; i < size; i++) {
    u8 byte           = toEncodeLittleEndian[i];
    result[2 * i]     = ((byte >> 0) & 15) + 'A';
    result[2 * i + 1] = ((byte >> 4) & 15) + 'A';
  }

  result[size * 2] = 0;
  if (len)
    *len = size * 2;
  return result;
}

u8* DecodeFromHex(const char* encoded, Arena* arena) {  ///
  const auto len = strlen(encoded);
  ASSERT(len > 0);
  ASSERT_FALSE(len % 2);

  u8* result = ALLOCATE_ARRAY(arena, u8, len / 2 + 1);

  FOR_RANGE (int, i, len / 2) {
    const u8 lower  = encoded[i * 2] - 'A';
    const u8 higher = encoded[i * 2 + 1] - 'A';
    result[i]       = (lower << 0) + (higher << 4);
  }
  result[len / 2 + 1] = 0;

  return result;
}

TEST_CASE ("EncodeToHex / DecodeFromHex") {  ///
  auto arena = MakeArena(260 * 4);

  u8* bytes = (u8*)BF_ALLOC(256);
  u8  prev  = 0;
  FOR_RANGE (int, i, 256) {
    bytes[i] = prev++;
  }

  auto t      = EncodeToHex(bytes, 256, &arena);
  auto result = DecodeFromHex(t, &arena);
  ASSERT(!memcmp(result, bytes, 256));
}

#ifdef SDL_PLATFORM_WINDOWS

struct PeekFiletimeResult {  ///
  bool     success  = false;
  SDL_Time filetime = {};
};

PeekFiletimeResult PeekFiletime(const char* filename) {  ///
  PeekFiletimeResult res{};

  WIN32_FIND_DATAA findData;
  auto             handle = FindFirstFileA(filename, &findData);

  if (handle != INVALID_HANDLE_VALUE) {
    res.success  = true;
    res.filetime = SDL_TimeFromWindows(
      findData.ftLastWriteTime.dwLowDateTime, findData.ftLastWriteTime.dwHighDateTime
    );
    ASSERT(FindClose(handle));
  }

  return res;
}

#endif

///
