import React from 'react';
import { GithubOutlined } from '@ant-design/icons';
import { DefaultFooter } from '@ant-design/pro-layout';

export default () => (
  <DefaultFooter
    copyright="xmmmmmovo"
    links={[
      {
        key: 'greenhouse',
        title: 'GreenHouseAdmin',
        href: 'https://github.com/xmmmmmovo/SmartGreenhouse',
        blankTarget: true,
      },
      {
        key: 'github',
        title: <GithubOutlined />,
        href: 'https://github.com/xmmmmmovo/SmartGreenhouse',
        blankTarget: true,
      },
    ]}
  />
);
