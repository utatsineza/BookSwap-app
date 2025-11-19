# Assignment 2 Submission Checklist

## ✅ Implementation Requirements

### 1. Authentication (4 points)
- [x] Firebase Auth signup
- [x] Firebase Auth login
- [x] Firebase Auth logout
- [x] Email verification enforced
- [x] User profile creation in Firestore
- [ ] **TODO**: Test email verification flow
- [ ] **TODO**: Screenshot Firebase console showing verified users

### 2. Book Listings - CRUD (5 points)
- [x] Create: Post books with title, author, condition, cover image
- [x] Read: Browse all listings feed
- [x] Update: Edit own listings
- [x] Delete: Remove own listings
- [ ] **TODO**: Implement image upload with Firebase Storage
- [ ] **TODO**: Test all CRUD operations
- [ ] **TODO**: Screenshot Firestore showing book documents

### 3. Swap Functionality (3 points)
- [x] Initiate swap offer button
- [x] Move listing to "My Offers" section
- [x] Change state to Pending
- [x] Real-time sync for both users
- [x] Accept/Reject functionality
- [ ] **TODO**: Test swap flow end-to-end
- [ ] **TODO**: Screenshot showing state changes in Firebase

### 4. State Management (4 points)
- [x] Provider implementation
- [x] AuthProvider
- [x] BookProvider
- [x] SwapProvider
- [x] ChatProvider
- [x] Real-time updates
- [ ] **TODO**: Document state management in video
- [ ] **TODO**: Explain Provider pattern in write-up

### 5. Navigation (2 points)
- [x] BottomNavigationBar
- [x] Browse Listings screen
- [x] My Listings screen
- [x] My Offers screen (replaces Chats in nav)
- [x] Settings screen
- [ ] **TODO**: Test navigation flow

### 6. Settings (2 points)
- [ ] **TODO**: Add notification toggle (local simulation)
- [ ] **TODO**: Display profile information
- [ ] **TODO**: Add logout button

### 7. Chat Feature - BONUS (5 points)
- [x] Chat system implemented
- [x] Real-time messaging
- [x] Firestore storage
- [x] Chat accessible after swap acceptance
- [ ] **TODO**: Test chat between two users
- [ ] **TODO**: Screenshot Firestore chat collection

## 📝 Deliverables Checklist

### 1. Write-up PDF (3 points)
- [ ] **TODO**: Document Firebase connection experience
- [ ] **TODO**: Include error screenshots (e.g., web compatibility issues)
- [ ] **TODO**: Explain how errors were resolved
- [ ] **TODO**: Include Dart Analyzer report screenshot
- [ ] **TODO**: Format as professional PDF

**How to get Dart Analyzer report:**
```bash
flutter analyze > analyzer_report.txt
# Take screenshot of output
```

### 2. GitHub Repository (7 points)
- [ ] **TODO**: Create GitHub repository
- [ ] **TODO**: Make at least 10 incremental commits with clear messages
- [ ] **TODO**: Ensure README.md is complete
- [ ] **TODO**: Add .gitignore (no Firebase credentials!)
- [ ] **TODO**: Include architecture diagram in README
- [ ] **TODO**: Document Firebase setup steps
- [ ] **TODO**: Verify Dart analyzer shows 0 warnings

**Commit Message Examples:**
```
feat: implement Firebase authentication with email verification
feat: add swap offer functionality with real-time updates
feat: implement chat system with Firestore
fix: resolve Book.fromMap parameter order issue
docs: add comprehensive README with setup instructions
refactor: improve state management with Provider pattern
```

### 3. Demo Video (7 points)
**Requirements:**
- [ ] **TODO**: 7-12 minutes long
- [ ] **TODO**: Show app AND Firebase console side-by-side
- [ ] **TODO**: Clear narration explaining each step
- [ ] **TODO**: Run on emulator or physical device (NOT browser!)

**Video Structure:**
1. Introduction (30 sec)
   - Show app overview
   - Mention technologies used

2. Authentication Flow (2 min)
   - Signup with email
   - Show verification email sent
   - Show Firebase console user created
   - Verify email
   - Login with verified account
   - Show Firebase console verification status

3. Book CRUD Operations (3 min)
   - Create new book listing
   - Show in Firebase console
   - Edit book details
   - Show update in console
   - Delete book
   - Show deletion in console
   - Browse all listings

4. Swap Functionality (3 min)
   - User A initiates swap on User B's book
   - Show swap document created in Firebase
   - Show book status changed to "pending"
   - User B receives offer
   - User B accepts offer
   - Show status update in Firebase
   - Both users see real-time update

5. Chat Feature (2 min)
   - Open chat after swap acceptance
   - Send messages between users
   - Show messages in Firebase console
   - Demonstrate real-time sync

6. State Management & Settings (1 min)
   - Explain Provider usage
   - Show settings screen
   - Demonstrate logout

**Recording Tools:**
- OBS Studio (free)
- Zoom (screen share + record)
- QuickTime (Mac)
- Windows Game Bar (Windows)

### 4. Design Summary PDF (3 points)
- [x] Database schema/ERD created
- [x] Swap state modeling explained
- [x] State management implementation documented
- [x] Design trade-offs discussed
- [x] Challenges documented
- [ ] **TODO**: Convert DESIGN_SUMMARY.md to PDF
- [ ] **TODO**: Add diagrams/screenshots if needed

## 🔧 Pre-Submission Tasks

### Code Quality
```bash
# Run analyzer
flutter analyze

# Format code
flutter format lib/

# Run tests (if any)
flutter test
```

### Firebase Console Checks
- [ ] Authentication enabled
- [ ] Email verification configured
- [ ] Firestore database created
- [ ] Security rules deployed
- [ ] Storage bucket created (for images)
- [ ] Test data visible in console

### Testing Checklist
- [ ] Signup with new email
- [ ] Receive verification email
- [ ] Login before verification (should fail)
- [ ] Verify email and login (should succeed)
- [ ] Create book listing
- [ ] Edit book listing
- [ ] Delete book listing
- [ ] Browse all books
- [ ] Initiate swap offer
- [ ] Receive swap offer
- [ ] Accept swap offer
- [ ] Reject swap offer
- [ ] Send chat message
- [ ] Receive chat message
- [ ] Logout and login again

### Device Requirements
- [ ] **CRITICAL**: Test on Android emulator OR iOS simulator OR physical device
- [ ] **DO NOT** submit video showing browser version
- [ ] Ensure app runs smoothly on mobile

## 📤 Final Submission

Create a single PDF containing:

1. **Cover Page**
   - Your name
   - Course name
   - Assignment title
   - Date

2. **Firebase Experience Write-up** (2-3 pages)
   - Connection process
   - Errors encountered with screenshots
   - Solutions implemented

3. **Dart Analyzer Report** (1 page)
   - Screenshot showing 0 warnings

4. **GitHub Repository Link** (1 line)
   - https://github.com/yourusername/bookswap-app

5. **Demo Video Link** (1 line)
   - YouTube/Google Drive/OneDrive link
   - Ensure video is publicly accessible

6. **Design Summary** (1-2 pages)
   - Database schema
   - Swap state modeling
   - State management explanation
   - Trade-offs and challenges

## 🎯 Grading Breakdown

| Criteria | Points | Status |
|----------|--------|--------|
| State Management & Architecture | 4 | ⏳ |
| Code Quality & Repository | 7 | ⏳ |
| Demo Video | 7 | ⏳ |
| Authentication | 4 | ✅ |
| Book Listings CRUD | 5 | ✅ |
| Swap Functionality | 3 | ✅ |
| Navigation & Settings | 2 | ⏳ |
| Deliverables Quality | 3 | ⏳ |
| Chat Feature (Bonus) | 5 | ✅ |
| **Total** | **40** | |

## 🚨 Common Mistakes to Avoid

1. ❌ Running app in browser instead of mobile
2. ❌ Committing Firebase credentials to GitHub
3. ❌ Video longer than 12 minutes or shorter than 7
4. ❌ Not showing Firebase console in video
5. ❌ Incomplete deliverables (missing PDF or video)
6. ❌ More than 30 Dart analyzer warnings
7. ❌ No incremental commits (single dump)
8. ❌ Email verification not enforced
9. ❌ No real-time updates for swaps
10. ❌ Chat not working or not implemented

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)

## ✨ Tips for Success

1. **Test Early, Test Often**: Don't wait until the last minute
2. **Commit Frequently**: Make small, incremental commits
3. **Document as You Go**: Take screenshots during development
4. **Practice Your Demo**: Record a practice video first
5. **Ask for Help**: Use office hours if stuck
6. **Read the Rubric**: Ensure you meet all criteria
7. **Backup Your Work**: Push to GitHub regularly

---

**Good luck with your submission! 🚀**
