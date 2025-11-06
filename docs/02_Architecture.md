# Architectural Design – StreamWise Netflix Project

## 1) What We're Actually Building

We're creating a database that answers one simple question: **Why are people scrolling forever and then giving up?**

To answer that, we need to track:
- How long someone scrolls before they pick something (or quit)
- Whether they actually watch what they picked
- Which recommendations are working vs. failing

**The approach:** No fancy machine learning, no complex pipelines. Just smart SQL and a well-designed database that tells the story.

---

## 2) How It Works (The User Journey)

Here's what we're capturing:


User Opens Netflix 
    ↓
Netflix Shows Recommendations
    ↓
User Scrolls Through Options
    ↓
Two Outcomes:
    → They pick something and watch (success!)
    → They give up and close the app (problem!)


We call each of these attempts a **View Session**—and that's what we're tracking.

---

## 3) The Database Structure (In Plain English)

Think of this like organizing information into filing cabinets:

| Table Name | What It Stores | Why We Need It |
|---|---|---|
| **DimUserProfile** | User personality types (casual viewer, binge-watcher, picky chooser, etc.) | Different people behave differently—we need to know WHO is struggling |
| **DimContent** | Show/movie details (genre, length, type) | Helps us see which content gets skipped or chosen |
| **DimDate** | Calendar information | Maybe Mondays are worse than Saturdays? |
| **DimTimeOfDay** | Morning, afternoon, evening, late night | People want different things at 3pm vs. 11pm |
| **FactViewSession** | The actual browsing and watching behavior | This is where the action happens—every scroll, every watch, every quit |

**Why this structure?** It mirrors how businesses actually think: "What happened, when, to whom, and with what content?"

---

## 4) The Heart of Everything: FactViewSession

This is where we capture what actually happened in each viewing attempt:

| What We Track | What It Tells Us |
|---|---|
| **ScrollDurationSec** | How long they browsed before making a choice (or giving up) |
| **WatchDurationMin** | How much they actually watched (if anything) |
| **DidUserWatch** | Simple yes/no: did they watch or quit? |
| **SatisfactionScore** | A rating (1-5) based on their behavior—did they seem happy with their choice? |

**This is the data that reveals decision fatigue.** If scroll time is high but watch rate is low? That's a red flag.

---

## 5) How Data Gets In (The ETL Flow)

ETL sounds fancy, but it's just: how does data get into the database?


Step 1: Create Realistic Test Data
    ↓
Step 2: Load It Into FactViewSession
    ↓
Step 3: Build Views That Calculate KPIs
    ↓
Step 4: Answer Business Questions


**Example:** We generate 100+ realistic viewing sessions—some users watch immediately, some scroll for 10 minutes then quit, some browse at 2am looking for comfort shows.

---

## 6) Why This Design Actually Works

Here's why this isn't just a "student project" structure—it's professional-grade:

**It's simple but powerful**
- Not over-engineered
- Anyone can understand it (product managers, analysts, developers)
- Easy to query and get insights fast

**It's scalable**
- Start with 100 sessions, scale to 100 million if needed
- Add new dimensions (like device type or subscription tier) without breaking anything

**It speaks business language**
- Executives don't care about tables and joins
- They care about: "Why are users leaving?" and "What should we fix?"
- This structure makes those answers easy to find

**It's interview-ready**
- Dimensional modeling (fact + dimension tables) is industry standard
- Interviewers immediately recognize this as proper data warehousing
- Shows I understand how real companies structure analytics databases

---

## The Bottom Line

This isn't just a database—it's a **decision-making tool**.

Product managers can ask: "Which recommendations are failing?"  
Business analysts can ask: "Which users need help?"  
SQL developers can ask: "How do I efficiently query this?"

**Everyone gets answers from the same clean, well-designed system.**

That's the mark of good architecture: it serves the people using it, not just the person who built it.
