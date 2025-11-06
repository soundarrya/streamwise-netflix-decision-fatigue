# KPI Insights – Decision Fatigue Analysis

This is where the data starts telling us stories about what's actually broken.

We built 3 key reports (KPI views) to measure the problem:

| Report Name | What It Tells Us |
|---|---|
| **vKPI_FatigueByRecommendationType** | Which recommendation categories make people scroll the most |
| **vKPI_FatigueByPersona** | Which types of users struggle the most to find content |
| **vKPI_DecisionFatigueScore** | One single number that ranks how badly a recommendation is failing |

Let's break down what we actually found.

---

## Key Insight 1 – Some Recommendations Are Useless

**What the data shows:**

Not all recommendation rows on Netflix work the same way. Some help users decide quickly. Others make them scroll forever.

**Example findings from the data:**

- **"Top Picks for You"** → High scroll time, low watch rate  
  *Translation: Netflix thinks these are good matches, but users clearly disagree*

- **"Continue Watching"** → Low scroll time, high watch rate  
  *Translation: This works because users already know they're interested*

**Why this matters:**

"Continue Watching" is successful because it matches what the user is *already in the mood for*. They're not taking a gamble—they're finishing something they started.

"Top Picks" is failing because the algorithm is guessing what you might like based on history, but it's not reading your mood *right now*.

**The takeaway:** Netflix should show more content types like "Continue Watching" (safe, aligned to current intent) and fewer experimental recommendations when users just want something familiar.

---

## Key Insight 2 – Different People Need Different Approaches

**What the data shows:**

Not all users behave the same way. We grouped users into personas based on their behavior patterns:

- **"Curious Explorer"** → Scrolls a LOT, trying to find something new and interesting  
  *They enjoy browsing, but they also give up more often*

- **"Comfort Rewatcher"** → Scrolls very little, picks familiar favorites  
  *They know what they want and find it quickly*

**Why this matters:**

Right now, Netflix probably shows everyone the same types of recommendations. But these two people need completely different experiences:

- **Curious Explorers** need better discovery tools (filters, mood-based browsing, "feeling lucky" buttons)
- **Comfort Rewatchers** need their favorites front and center immediately

**The takeaway:** One-size-fits-all recommendations don't work. Netflix should adapt the homepage based on user personality type.

---

## Key Insight 3 – We Can Rank What to Fix First

**What the data shows:**

The **Decision Fatigue Score** gives us one single number that combines:
- How long people scrolled
- Whether they actually watched
- How satisfied they seemed

**Why this matters:**

Product teams have limited time and resources. They can't fix everything at once.

This score lets them prioritize:
- **"Fix this first"** → High fatigue score = users are really struggling here
- **"This is working"** → Low fatigue score = leave it alone
- **"Quick win"** → Medium fatigue with an obvious fix = do this soon

**Example decision it enables:**

Instead of guessing "maybe we should redesign the whole homepage," they can say: "Our data shows that Tuesday evening recommendations for Curious Explorers have a fatigue score of 8.2—that's the highest risk segment. Let's start there."

**The takeaway:** This turns "we should improve recommendations" (vague) into "we should fix X for Y users first" (actionable).

---

## Why These Insights Matter

Here's the shift this analysis creates:

**Before:** Netflix product managers rely on gut feeling  
→ "I think users are frustrated with recommendations"

**After:** They have measurable, prioritized insights  
→ "Continue Watching has a 40% better watch rate than Top Picks. Curious Explorers scroll 3x longer than Comfort Rewatchers. We should redesign recommendations for Explorers on weeknight evenings first—that's our highest fatigue score segment."

---

## The Business Impact

These aren't just "interesting insights"—they're **decisions waiting to be made**:

**Decision 1:** Reduce experimental recommendations for users who just want comfort content  
**Decision 2:** Build better discovery tools for users who enjoy exploring  
**Decision 3:** Prioritize UX improvements based on fatigue score, not guesswork

**This is what separates data analysis from data storytelling.**

I'm not just showing numbers—I'm showing Netflix exactly what to do next and why it matters.
