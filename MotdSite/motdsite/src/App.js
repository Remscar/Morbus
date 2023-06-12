import React from 'react';
import MOTD from './components/MOTD';

const App = () => {
  return (
    <div className="app">
      <header>
        {/* Other header content */}
      </header>

      <main>
        <MOTD />
        {/* Other main content */}
      </main>

      <footer>
        {/* Other footer content */}
      </footer>
    </div>
  );
};

export default App;
