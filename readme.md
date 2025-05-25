## 🔧 Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://github.com/SREEYUKTHA-SNL/newsapp.git
   cd newsapp
   ------------------------------------------------------------
   
🧱 Architecture Choices
MVVM (Model-View-ViewModel):

Keeps business logic separate from UI.

Makes testing and scalability easier.

Provider:Lightweight and efficient for handling shared app state.

Used for authentication, bookmarks, dark mode, and news data.

WebView Integration:Full articles are opened within the app using webview_flutter.

Search Functionality:Implemented with SearchDelegate to provide native search experience.

------------------------------------------------------
provider:	State management for theming, auth, and data.
http:	Fetching news data from the internet.
shared_preferences:	Saving user preferences (e.g., theme mode).
intl:	Formatting publication dates in a readable format.
webview_flutter	:Displaying full articles within the app.

