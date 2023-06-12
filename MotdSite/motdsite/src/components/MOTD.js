import React from 'react';

const MOTD = () => {
  return (
    <div className="motd-container">
      <h2 className="motd-title">Welcome to the Morbus Renaissance!</h2>
      <hr className="motd-divider" />

      <div className="motd-rules">
        <h3 className="motd-section-title">Server Rules:</h3>
        <ol className="motd-rule-list">
          <li>Respect other players and staff members.</li>
          <li>No cheating, hacking, or exploiting bugs.</li>
          <li>No excessive trolling or harassment.</li>
          <li>Do not spam or advertise other servers.</li>
          <li>Use common sense and have fun!</li>
        </ol>
      </div>

      <div className="motd-features">
        <h3 className="motd-section-title">Server Features:</h3>
        <ul className="motd-feature-list">
          <li>Friendly and active community.</li>
          <li>Customized maps and unique gameplay modes.</li>
          <li>Regular events and giveaways.</li>
          <li>Active and responsive staff members.</li>
          <li>ULX commands for enhanced control.</li>
        </ul>
      </div>

      <div className="motd-commands">
        <h3 className="motd-section-title">Important Commands:</h3>
        <ul className="motd-command-list">
          <li>!help: Displays a list of available commands.</li>
        </ul>
      </div>
    </div>
  );
};

export default MOTD;
